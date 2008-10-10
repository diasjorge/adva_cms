var CommentForm = {
  init: function() {
    var username = Cookie.get('uname');
    if (username) {
			try { $$('#registered_author span')[0].update(username); } catch(err) {}
			try { $('registered_author').show(); } catch(err) {}
			try { $('anonymous_author').hide(); } catch(err) {}
    }
  }
}

Date.UTCNow = function() {
  d = new Date();
  utc = new Date(Date.UTC(d.getUTCFullYear(), d.getUTCMonth(), d.getUTCDate(), d.getUTCHours(), d.getUTCMinutes(), d.getUTCSeconds()));
  // we need to correct the timezone offset because JS sucks really bad with timezones ...
  return new Date(utc.getTime() + utc.getTimezoneOffset()*60000);
}

// parse an ISO8601 UTC date string (YYYY-mm-ddZHH:MM:SSZ)
Date.parseISO8601 = function(iso8601_date) {
  return new Date(Date.parse(iso8601_date.replace(/-/g, '/').replace('T', ' ').substr(0, 19))); // always has exactly 19 chars
}

distanceOfTimeInWords = function(seconds) {
  d = seconds/60; // in minutes

  if (d < 1) return 'less than a minute';

  d = Math.ceil(d); // if it's more than a minute, ceil it
  if (d < 50) return (d + ' minute' + (d == 1 ? '' : 's'));
  if (d < 90) return 'about one hour';
  if (d < 1080) return (Math.round(d/60) + ' hours');
  if (d < 1440) return 'one day';
  if (d < 2880) return 'about one day';
  else return (Math.round(d/1440) + ' days');
}

timeAgoInWords = function(iso8601_date) {
  utc_date = Date.parseISO8601(iso8601_date);
  utc_now  = Date.UTCNow();
  d = (utc_now.getTime() - utc_date.getTime())/1000; // in seconds

  return distanceOfTimeInWords(d) + ' ago';
}

createAndFormatDateSpan = function(abbr) {
  // create a new span element and set its title to the abbr's innerHTML and its value to the timeAgoInWords string
  abbr.update(new Element('span', { title: abbr.innerHTML }).update(timeAgoInWords(abbr.title))); // only used for past dates right now so we can safely use time_ago_in_words here
}

Event.onReady(function() {
  if($('anonymous_author')) {
	  CommentForm.init();
  }
  // parse all microformatted dates and re-format them as time distance
  $$('abbr.datetime').each(function(abbr) {
    createAndFormatDateSpan(abbr);
  });
});
