Event.addBehavior({
  '#section_locale:change': function() { window.location.href = '?cl=' + this.value; }
});