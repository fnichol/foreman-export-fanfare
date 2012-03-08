require 'minitest/autorun'
require 'mocha'
require 'foreman/engine'
require 'foreman/export/fanfare_runit'

class Foreman::Export::FanfareRunit::Service ; end

describe Foreman::Export::FanfareRunit do
  let(:app_name)          { 'fooapp' }
  let(:service_root_path) { Pathname.new('/export/home/deploy/service') }
  let(:engine)            { Foreman::Engine.new('/Procfile') }
  let(:procfile)          { "stub: command" }
  let(:service)           { mock('Service') }

  before do
    File.stubs(:read => procfile)
  end

  describe "#export" do
    it "raises an exception if no location is given" do
      subject   = Foreman::Export::FanfareRunit.new(nil, engine)

      proc { subject.export }.must_raise Foreman::Export::Exception
    end

    describe "for a single process type" do
      subject do
        Foreman::Export::FanfareRunit.new(
          service_root_path.to_s, engine, :app => app_name)
      end

      let(:service_type)  { "clock" }
      let(:command)       { "bundle exec clock.rb" }
      let(:procfile)      { "#{service_type}: #{command}" }
      let(:service_name)  { "#{app_name}-#{service_type}-1" }
      let(:port)          { 5555 }
      let(:env)           do { 'SOME' => 'SETTINGS' } end

      before do
        engine.stubs(:port_for).with(kind_of(Foreman::ProcfileEntry), 1, nil).
          returns(port)
        engine.stubs(:environment).returns(env)

        Foreman::Export::FanfareRunit::Service.stubs(:new).
          with(service_name, command, service_root_path,
               { 'PORT' => port }.merge(env)).
          returns(service)

        service.stubs(:create!)
        service.stubs(:activate!)
      end

      it "initializes a Service for the process with its options" do
        Foreman::Export::FanfareRunit::Service.expects(:new).
          with(service_name, command, service_root_path,
               { 'PORT' => port }.merge(env)).
          returns(service)

        subject.export
      end

      it "creates the Service" do
        service.expects(:create!).once

        subject.export
      end

      it "activates the Service" do
        service.expects(:activate!).once

        subject.export
      end
    end

    describe "for multiple process types with concurrency options" do
      subject do
        Foreman::Export::FanfareRunit.new(
          service_root_path.to_s, engine,
          :app => app_name, :concurrency => 'web=1,worker=2')
      end

      let(:procfile) do
        <<-PROCFILE.gsub(/^ {10}/, '')
          web:    bundle exec servars
          worker: bundle exec wurkarz
        PROCFILE
      end

      before do
        Foreman::Export::FanfareRunit::Service.stubs(:new).returns(service)
        service.stubs(:create!)
        service.stubs(:activate!)
      end

      it "initializes a Service for the web process" do
        Foreman::Export::FanfareRunit::Service.expects(:new).
          with("fooapp-web-1", "bundle exec servars",
               service_root_path, kind_of(Hash)).
          returns(service)

        subject.export
      end

      it "initializes 2 Services for the worker processes" do
        Foreman::Export::FanfareRunit::Service.expects(:new).
          with("fooapp-worker-1", "bundle exec wurkarz",
               service_root_path, kind_of(Hash)).
          returns(service)
        Foreman::Export::FanfareRunit::Service.expects(:new).
          with("fooapp-worker-2", "bundle exec wurkarz",
               service_root_path, kind_of(Hash)).
          returns(service)

        subject.export
      end

      it "creates the Services" do
        service.expects(:create!).times(3)

        subject.export
      end

      it "activates the Services" do
        service.expects(:activate!).times(3)

        subject.export
      end
    end
  end
end
