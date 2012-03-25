class Reaction < ActiveRecord::Base

  belongs_to :commit_diff
  belongs_to :user
  has_many :commits, :through => :commit_diff
    
  
  def status=(value)
    if value == "Accept"
      self[:status] = true
    else
      self[:status] = false
    end
  end

  def accepted?
    self[:status] == 1
  end

  def declined?
    self[:status] == 0
  end
  
protected

  def status
  end
  
end
