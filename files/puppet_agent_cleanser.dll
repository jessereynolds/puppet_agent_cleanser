metadata :name        => "puppet_agent_cleanser",
         :description => "Cleanse the run state of Puppet agents",
         :author      => "Jesse Reynolds",
         :license     => "Apache",
         :version     => "0.1",
         :url         => "https://github.com/jessereynolds/puppet_agent_cleanser",
         :timeout     => 60

requires :mcollective => "2.1.2"

action "status", :description => "Gets the run state of the Puppet agent" do
    display :always

    output :status,
           :description => "The run state of the Puppet agent",
           :display_as  => "Puppet Agent Status",
           :default     => "unknown status"
end

action "cleanse", :description => "Cleanse the run state of the Puppet agent" do
    display :always

    output :results,
           :description => "Result of the cleanse operation",
           :display_as  => "Cleanse result",
           :default     => "unknown"
end

