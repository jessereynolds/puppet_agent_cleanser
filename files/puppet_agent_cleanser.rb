module MCollective
  module Agent
    class PuppetAgentCleanser < RPC::Agent
      action "status" do
        reply[:status] = "Not implemented"
      end

      action "cleanse" do
        reply[:results] = "Not implemented"
      end
    end
  end
end

