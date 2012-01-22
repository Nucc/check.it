module WallHelper

  def refer_to(patch)
    title = patch.message.split("\n")[0]
    return link_to  change_endlines(title), repository_patch_url(patch.repository, patch)
  end

  def description(patch)
    patch.message.split("\n")[1..-1] * "\n"
  end

end
