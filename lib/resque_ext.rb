module ResqueExt
  def self.unregister_workers
    Resque.workers.select{|worker| worker.id.split(':').first != Resque::Worker.all.first.hostname}.each(&:unregister_worker)
  end
end