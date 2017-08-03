require 'spec_helper_acceptance'

describe command('puppet inventory all') do
  its(:exit_status) { is_expected.to eq 0 }
  its(:stdout) { is_expected.to match %r{"virtual": "docker"} }
  its(:stdout) { is_expected.to match %r{"resource": "package"} }
end

describe command('puppet inventory facts') do
  its(:exit_status) { is_expected.to eq 0 }
  its(:stdout) { is_expected.to match %r{"virtual": "docker"} }
end

describe command('puppet inventory resources') do
  its(:exit_status) { is_expected.to eq 0 }
  its(:stdout) { is_expected.to match %r{"resource": "package"} }
end

describe command('puppet inventory catalog') do
  its(:exit_status) { is_expected.to eq 0 }
end

describe command('puppet inventory report') do
  its(:exit_status) { is_expected.to eq 0 }
end
