def move_git_reference(branch, commit)
  result = %x[ cd #{CONFIG["repository_path"]}/update_test.git && git checkout #{branch.to_s} > /dev/null 2>&1 && git reset --hard #{commit.to_s} ]
end

def branch_reference(branch)
  r = %x[ cd #{CONFIG["repository_path"]}/update_test.git && git show #{branch.to_s} -v | head -4 | grep commit | cut -d" " -f2- ]
  return r.strip
end

def fetch(remote)
  %x[ cd #{CONFIG["repository_path"]}/update_test.git && git fetch #{remote.to_s} > /dev/null 2>&1 ]
end