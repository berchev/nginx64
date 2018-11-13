describe os.name do
  it { should eq 'ubuntu' }
end

describe os.release do
  it { should eq '16.04' }
end

describe filesystem('/') do
  its('size') { should be >= 10000000 }
end

describe package('nginx') do
  it { should be_installed }
end

describe service('nginx') do
  it { should be_running }
  it { should be_enabled }
end

describe nginx do
  its('version') { should eq '1.10.3' }
end

describe file('/var/www/html') do
  it { should exist }
end

describe http('http://localhost') do
  its('status') { should cmp 200 }
  its('body') { should match 'Welcome to nginx!' }
end

