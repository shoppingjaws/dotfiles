local M = {}

function M.get_git_root_dirname(path)
  -- gitリポジトリのルートディレクトリを探す
  local git_root = nil
  local current_path = path

  while current_path and current_path ~= "/" do
    local git_dir = current_path .. "/.git"
    local file = io.open(git_dir, "r")
    if file then
      file:close()
      git_root = current_path
      break
    else
      -- .gitディレクトリが存在しない場合は親ディレクトリをチェック
      current_path = current_path:match("(.*)/.+")
    end
  end

  if git_root then
    -- gitリポジトリのルートディレクトリ名を取得
    local dirname = git_root:match("([^/]+)/?$") or git_root
    return dirname
  end

  return nil
end

return M