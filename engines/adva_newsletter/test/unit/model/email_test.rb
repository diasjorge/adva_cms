require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class EmailTest < ActiveSupport::TestCase
  def setup
    super
    @email = Email.create! :from => "admin@example.com",
                           :to   => "user@example.com",
                           :mail => "add valid email here"
  end
  
  def teardown
    super
    remove_all_test_cronjobs
  end
  
  test "validations" do
    @email.should be_valid
    @email.should validate_presence_of(:from)
    @email.should validate_presence_of(:to)
    @email.should validate_presence_of(:mail)
  end

  test "##start_delivery should create a cronjob with command Email.deliver_all" do
    response = Email.start_delivery
    response.class.should == Cronjob 
    response.command.should == "Email.deliver_all"
  end
  
  test "##deliver_all should autoremove cronjob when all emails are delivered" do
    Cronjob.create :cron_id => "email_deliver_all", :command => "test"
    Email.destroy_all
    Email.deliver_all
    Cronjob.find_by_cron_id("email_deliver_all").should be_nil
  end
  
  test "outgoing mails per process should be 150" do
    Adva::Config.number_of_outgoing_mails_per_process = nil
    Adva::Config.number_of_outgoing_mails_per_process.should == 150
  end
end
