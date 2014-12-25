构建EayunOS产品的相关内容
======
### EayunOS 4.1

EayunOS 4.1 构建由 2 个部分组成： packaging 和 iso-building 。

#### packaging

需要自行维护的软件包，以软件包对应的上游项目为基本单位，每个项目建一个目录。

项目目录之下，包含一个 upstream 目录、若干 patch 文件以及一个 Makefile 。

其中：

* upstream 目录，对应 git submodule 形式的上游代码；
* 对上游的变更都使用 git format-patch 生成 patch 文件；
* Makefile ，提供给 Koji 系统使用，至少包含一个 sources 目标，执行 `make sources` 时，apply 所有 patch ，并生成 tarball 压缩包，以构建最终的 RPM 安装包。

目前维护的软件包有：

* [livecd](packaging/livecd)
* [ovirt-hosted-engine-setup](packaging/ovirt-hosted-engine-setup)
* [ovirt-node](packaging/ovirt-node)
* [ovirt-node-plugin-hosted-engine](packaging/ovirt-node-plugin-hosted-engine)
* [ovirt-node-plugin-vdsm](packaging/ovirt-node-plugin-vdsm)
* [vdsm](packaging/vdsm)

#### iso-building

包括 [ovirt-node-iso](iso-building/ovirt-node-iso) （同样使用 git submodule ）以及针对 EayunOS 的 Makefile.am 、 configure.ac 和 recipe 文件。

### EayunOS 4.0

EayunOS 4.0 构建相关内容移至 4.0 目录之下， 构建内容主要包括，All in One光盘的生成，oVirt Node的编译打包，以及oVirt-Node光盘的生成。

项目目录中主要用来保存构建过程对上游项目改动的地方，以及自行编写的配置本件、脚本等。

### Wiki
构建过程相关文档请查看项目Wiki：

[EayunOS-building Wiki](https://github.com/eayun/EayunOS-building/wiki)
