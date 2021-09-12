module Main
  module Views
    module Orgs
      class Members
        include Main::View
        layout :user
      end
    end
  end
end
