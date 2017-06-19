module MCollective
  module Agent
    class PuppetAgentCleanser < RPC::Agent
      action "status" do
        reply[:msg] = request[:msg]
      end

      action "clean" do
        reply[:msg] = request[:msg]
      end
    end
  end
end

