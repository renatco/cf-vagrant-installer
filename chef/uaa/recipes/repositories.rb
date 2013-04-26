apt_repository "hardy" do
  uri "http://archive.ubuntu.com/ubuntu"
  distribution "hardy"
  components %w(main multiverse)
end

apt_repository "hardy-update" do
  uri "http://archive.ubuntu.com/ubuntu"
  distribution "hardy-updates"
  components %w(main multiverse)
end
