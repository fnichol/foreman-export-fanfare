require 'minitest/autorun'
require 'foreman/export/fanfare_runit/service'

describe Foreman::Export::FanfareRunit::Service do
  subject do
    Foreman::Export::FanfareRunit::Service.new(
      "foo-service", "bundle exec agogo", "/etc/service", { 'COOL' => 'yep' })
  end

  describe "#initialize" do
    it "stores the service name" do
      subject.name.must_equal "foo-service"
    end

    it "stores the command" do
      subject.command.must_equal "bundle exec agogo"
    end

    it "stores the service root path" do
      subject.service_root_path.must_equal "/etc/service"
    end

    it "stores the environment" do
      subject.environment.must_equal({ 'COOL' => 'yep' })
    end
  end
end
