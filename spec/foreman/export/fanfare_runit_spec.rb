require 'minitest/autorun'
require 'mocha'
require 'foreman/engine'
require 'foreman/export/fanfare_runit'

class Foreman::Export::FanfareRunit::Service ; end

describe Foreman::Export::FanfareRunit do
  let(:app_name)      { 'fooapp' }
  let(:location_path) { Pathname.new('/export/home/deploy/service') }
  let(:engine)        { Foreman::Engine.new('/Procfile') }
  let(:procfile)      { "stub: command" }
  let(:service)       { mock('Service') }

  before do
    File.stubs(:read => procfile)
  end

  describe "#export" do
    subject do
      Foreman::Export::FanfareRunit.new(
        location_path.to_s, engine, :app => app_name)
    end

    it "raises an exception if no location is given" do
      subject   = Foreman::Export::FanfareRunit.new(nil, engine)

      proc { subject.export }.must_raise Foreman::Export::Exception
    end

    describe "for a single process type" do
      let(:service_type)  { "clock" }
      let(:command)       { "bundle exec clock.rb" }
      let(:procfile)      { "#{service_type}: #{command}" }
      let(:service_name)  { "#{app_name}-#{service_type}-1" }

      it "exports the process with its options" do
        Foreman::Export::FanfareRunit::Service.expects(:new).
          with(service_name, command).returns(service)

        subject.export
      end
    end
  end
end
