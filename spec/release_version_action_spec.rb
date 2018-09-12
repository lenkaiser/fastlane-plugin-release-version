describe Fastlane::Actions::ReleaseVersionAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The release_version plugin is working!")

      Fastlane::Actions::ReleaseVersionAction.run(nil)
    end
  end
end
