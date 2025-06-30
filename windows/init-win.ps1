$install_cmd = "winget install -e --accept-source-agreements --accept-package-agreements "
$packages = "--id AgileBits.1Password", "--id Git.Git", "--id Neovim.Neovim", "--id vim.vim", "--id equalsraf.neovim-qt", "--id OpenRocket.OpenRocket --version 23.09", "--id Inkscape.Inkscape",  "--id SumatraPDF.SumatraPDF", "--id Obsidian.Obisdian", "--id JGraph.Draw", "--id Valve.Steam", "--id Appest.TickTick", "--id Apple.iTunes", "--id Genymobile.scrcpy", "--id dotPDN.PaintDotNet", "--name MusicBee", "--id LLVM.clangd", "--id LLVM.LLVM", "--id Zig.Zig", "--id Oracle.JDK.17", "--id Python.Python", "--id OpenJS.NodeJS.LTS --version 16.17.1", "--id Kitware.CMake", "--id Microsoft.PowerToys"

foreach ($package in $packages) 
{
	$install_call = $install_cmd + $package
	iex $install_call
}

git clone https://github.com/yevagorbachev/sys-setup
cd sys-setup

cp wsl\.vimrc $env:userprofile
cp wsl\.vim $env:userprofile\vimfiles -r
cp wsl\.config\nvim $env:localappdata

reg import windows\yeva.reg

cd ..

wsl --install
