# 道路 (Daolu) - 中文版 OpenCode

道路是 [OpenCode](https://github.com/anomalyco/opencode) 的中文本地化版本，提供完整的中文界面和九宫格启动画面。

## 功能特点

- 完整的中文界面翻译
- 九宫格太极启动画面
- 所有菜单、对话框、提示信息均已汉化
- 与上游 OpenCode 保持同步

## 安装

### 一键安装（推荐）

```bash
curl -fsSL https://raw.githubusercontent.com/taobaoww2010-alt/daolu/main/install.sh | bash
```

### 手动安装

#### macOS

```bash
# 下载最新版本
curl -L https://github.com/taobaoww2010-alt/daolu/releases/latest/download/daolu-darwin-arm64 -o ~/.local/bin/daolu
chmod +x ~/.local/bin/daolu

# 添加到 PATH（如果还没有）
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

#### Linux

```bash
# 下载最新版本
curl -L https://github.com/taobaoww2010-alt/daolu/releases/latest/download/daolu-linux-x64 -o ~/.local/bin/daolu
chmod +x ~/.local/bin/daolu

# 添加到 PATH
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### 从源码构建

```bash
# 克隆仓库
git clone https://github.com/taobaoww2010-alt/daolu.git
cd daolu

# 构建
make build

# 安装
make install
```

## 使用

安装完成后，直接运行：

```bash
daolu
```

## 配置

道路使用与 OpenCode 相同的配置文件：

- 配置目录：`~/.config/opencode/`
- 工作空间：当前目录

## 更新

### 自动更新

重新运行安装脚本即可更新到最新版本：

```bash
curl -fsSL https://raw.githubusercontent.com/taobaoww2010-alt/daolu/main/install.sh | bash
```

### 手动更新

```bash
# 删除旧版本
rm ~/.local/bin/daolu

# 重新安装
curl -L https://github.com/taobaoww2010-alt/daolu/releases/latest/download/daolu-$(uname -s | tr '[:upper:]' '[:lower:]')-$(uname -m) -o ~/.local/bin/daolu
chmod +x ~/.local/bin/daolu
```

## 开发

### 项目结构

```
daolu/
├── patches/              # 中文化补丁
│   └── packages/
│       ├── tui/          # TUI 界面补丁
│       └── opencode/     # 核心功能补丁
├── script/
│   ├── build.sh          # 构建脚本
│   └── update-patches.sh # 更新补丁脚本
├── .github/
│   └── workflows/
│       └── build.yml     # GitHub Actions 工作流
├── install.sh            # 安装脚本
├── Makefile              # 构建命令
└── README.md             # 本文档
```

### 添加新的翻译

1. 编辑 `patches/packages/tui/src/util/zh.ts`
2. 添加新的翻译条目：
   ```typescript
   "English text": "中文翻译",
   ```
3. 在对应的源文件中使用 `zh()` 函数包装文本

### 更新到新版本 OpenCode

1. 更新 `OPENCODE_VERSION` 变量
2. 运行 `make update-patches`
3. 测试构建
4. 提交更改

## 贡献

欢迎提交 Issue 和 Pull Request！

## 许可证

MIT License - 与 OpenCode 相同

## 致谢

- [OpenCode](https://github.com/anomalyco/opencode) - 原始项目
- 所有贡献者
