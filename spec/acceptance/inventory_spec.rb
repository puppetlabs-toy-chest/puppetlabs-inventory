require 'spec_helper_acceptance'

describe command('puppet inventory all') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match /"virtual": "docker"/ }
  its(:stdout) { should match /"resource": "package"/ }
end

describe command('puppet inventory facts') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match /"virtual": "docker"/ }
end

describe command('puppet inventory resources') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match /"resource": "package"/ }
end

describe command('puppet inventory catalog') do
  its(:exit_status) { should eq 0 }
end

describe command('puppet inventory report') do
  its(:exit_status) { should eq 0 }
end
