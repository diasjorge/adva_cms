user      = User.find_by_first_name('a user')
moderator = User.find_by_first_name('a moderator')
admin     = User.find_by_first_name('an admin')
superuser = User.find_by_first_name('a superuser')

message =
Message.create! :sender     => user,
                :recipient  => moderator,
                :subject    => 'a message to the moderator subject',
                :body       => 'a message to the moderator body'
                                  
Message.create! :sender     => superuser,
                :recipient  => admin,
                :subject    => 'a message to the admin subject',
                :body       => 'a message to the admin body'
                
Message.create! :sender     => superuser,
                :recipient  => superuser,
                :subject    => 'a message to self subject',
                :body       => 'a message to self body'

reply = Message.reply_to(message)
reply.sender = moderator
reply.body   = 'a reply to the message'
reply.save!

