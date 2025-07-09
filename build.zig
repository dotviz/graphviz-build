const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const graphviz_dep = b.dependency("graphviz", .{
        .target = target,
        .optimize = optimize,
    });

    const lib = b.addStaticLibrary(.{
        .name = "graphvizstatic",
        .target = target,
        .optimize = optimize,
    });
    lib.addCSourceFile(.{ .file = .{
        .cwd_relative = "src/dummy.c",
    } });
    lib.addIncludePath(graphviz_dep.path("lib/cdt"));
    lib.addIncludePath(graphviz_dep.path("lib/cgraph"));
    lib.linkLibC();

    const config_h = b.addConfigHeader(.{
        .style = .blank,
        .include_path = "config.h",
    }, .{
        .HAVE_TCL = 0,
        .DEFAULT_DPI = 96,
        .HAVE_EXPAT = 1,
        .HAVE_SYS_MMAN_H = 1,
    });
    lib.installConfigHeader(config_h);
    const builddate_h = b.addConfigHeader(.{
        .style = .blank,
        .include_path = "builddate.h",
    }, .{
        .PACKAGE_VERSION = "a",
        .BUILDDATE = "a",
    });
    lib.installConfigHeader(builddate_h);

    const lib_cdt = b.addStaticLibrary(.{
        .name = "cdt",
        .target = target,
        .optimize = optimize,
    });
    lib_cdt.addCSourceFiles(.{
        .root = graphviz_dep.path("lib/cdt"),
        .files = &src_cdt,
    });
    lib_cdt.addIncludePath(graphviz_dep.path("lib"));
    lib_cdt.addIncludePath(graphviz_dep.path("lib/cdt"));
    lib_cdt.linkLibC();
    lib.linkLibrary(lib_cdt);

    const lib_cgraph = b.addStaticLibrary(.{
        .name = "cgraph",
        .target = target,
        .optimize = optimize,
    });
    lib_cgraph.addCSourceFiles(.{
        .root = graphviz_dep.path("lib/cgraph"),
        .files = &src_cgraph,
    });
    lib_cgraph.addIncludePath(.{ .cwd_relative = "inc/cgraph" });
    lib_cgraph.addCSourceFile(.{
        .file = .{
            .cwd_relative = "src/cgraph/grammar.c",
        },
    });
    lib_cgraph.addCSourceFile(.{
        .file = .{
            .cwd_relative = "src/cgraph/scan.c",
        },
    });
    lib_cgraph.addIncludePath(graphviz_dep.path("lib"));
    lib_cgraph.addIncludePath(graphviz_dep.path("lib/cdt"));
    lib_cgraph.addIncludePath(graphviz_dep.path("lib/cgraph"));
    lib_cgraph.addConfigHeader(config_h);
    lib_cgraph.linkLibC();
    lib.linkLibrary(lib_cgraph);

    const lib_common = b.addStaticLibrary(.{
        .name = "gvc",
        .target = target,
        .optimize = optimize,
    });
    lib_common.addIncludePath(.{ .cwd_relative = "inc" });
    lib_common.addIncludePath(.{ .cwd_relative = "inc/common" });
    lib_common.addCSourceFiles(.{
        .root = graphviz_dep.path("lib/common"),
        .files = &src_common,
    });
    lib_common.addCSourceFiles(.{
        .root = .{ .cwd_relative = "src/common/" },
        .files = &.{
            "htmlparse.c",
        },
    });
    lib_common.addIncludePath(graphviz_dep.path("lib"));
    lib_common.addIncludePath(graphviz_dep.path("lib/cdt"));
    lib_common.addIncludePath(graphviz_dep.path("lib/cgraph"));
    lib_common.addIncludePath(graphviz_dep.path("lib/gvc"));
    lib_common.addIncludePath(graphviz_dep.path("lib/common"));
    lib_common.addIncludePath(graphviz_dep.path("lib/pathplan"));
    lib_common.addConfigHeader(config_h);
    lib_common.addConfigHeader(builddate_h);
    lib_common.linkLibC();

    const lib_util = b.addStaticLibrary(.{
        .name = "util",
        .target = target,
        .optimize = optimize,
    });
    lib_util.addCSourceFiles(.{
        .root = graphviz_dep.path("lib/util"),
        .files = &src_util,
    });
    lib_util.addIncludePath(graphviz_dep.path("lib"));
    lib_util.addIncludePath(graphviz_dep.path("lib/util"));
    lib_util.linkLibC();

    const lib_gvc = b.addStaticLibrary(.{
        .name = "gvc",
        .target = target,
        .optimize = optimize,
    });
    lib_gvc.addCSourceFiles(.{
        .root = graphviz_dep.path("lib/gvc"),
        .files = &src_gvc,
    });
    lib_gvc.addIncludePath(graphviz_dep.path("lib"));
    lib_gvc.addIncludePath(graphviz_dep.path("lib/cdt"));
    lib_gvc.addIncludePath(graphviz_dep.path("lib/cgraph"));
    lib_gvc.addIncludePath(graphviz_dep.path("lib/gvc"));
    lib_gvc.addIncludePath(graphviz_dep.path("lib/common"));
    lib_gvc.addIncludePath(graphviz_dep.path("lib/pathplan"));
    // ltdl.h
    // lib_gvc.addIncludePath(.{ .cwd_relative = "inc/" });
    lib_gvc.addConfigHeader(config_h);
    lib_gvc.addConfigHeader(builddate_h);
    lib_gvc.linkLibC();
    lib_gvc.linkLibrary(lib_common);
    lib_gvc.linkLibrary(lib_util);
    lib.linkLibrary(lib_gvc);

    const lib_xdot = b.addStaticLibrary(.{
        .name = "xdot",
        .target = target,
        .optimize = optimize,
    });
    lib_xdot.addCSourceFile(.{
        .file = .{
            .dependency = .{
                .dependency = graphviz_dep,
                .sub_path = "lib/xdot/xdot.c",
            },
        },
    });
    lib_xdot.addIncludePath(graphviz_dep.path("lib"));
    lib_xdot.linkLibC();
    lib.linkLibrary(lib_xdot);

    const lib_pathplan = b.addStaticLibrary(.{
        .name = "pathplan",
        .target = target,
        .optimize = optimize,
    });
    lib_pathplan.addCSourceFiles(.{
        .root = graphviz_dep.path("lib/pathplan"),
        .files = &src_pathplan,
    });
    lib_pathplan.addIncludePath(graphviz_dep.path("lib"));
    lib_pathplan.addIncludePath(graphviz_dep.path("lib/pathplan"));
    lib_pathplan.linkLibC();
    lib.linkLibrary(lib_pathplan);

    const lib_dotgen = b.addStaticLibrary(.{
        .name = "dotgen",
        .target = target,
        .optimize = optimize,
    });
    lib_dotgen.addCSourceFiles(.{
        .root = graphviz_dep.path("lib/dotgen"),
        .files = &src_dotgen,
    });
    lib_dotgen.addIncludePath(graphviz_dep.path("lib"));
    lib_dotgen.addIncludePath(graphviz_dep.path("lib/dotgen"));
    lib_dotgen.addIncludePath(graphviz_dep.path("lib/common"));
    lib_dotgen.addIncludePath(graphviz_dep.path("lib/gvc"));
    lib_dotgen.addIncludePath(graphviz_dep.path("lib/pathplan"));
    lib_dotgen.addIncludePath(graphviz_dep.path("lib/cdt"));
    lib_dotgen.addIncludePath(graphviz_dep.path("lib/cgraph"));
    lib_dotgen.addConfigHeader(config_h);
    lib_dotgen.linkLibC();
    lib.linkLibrary(lib_dotgen);

    const lib_plugin_dot_layout = b.addStaticLibrary(.{
        .name = "dot_layout",
        .target = target,
        .optimize = optimize,
    });
    lib_plugin_dot_layout.addCSourceFile(.{
        .file = .{
            .dependency = .{
                .dependency = graphviz_dep,
                .sub_path = "plugin/dot_layout/gvlayout_dot_layout.c",
            },
        },
    });
    lib_plugin_dot_layout.addCSourceFile(.{
        .file = .{
            .dependency = .{
                .dependency = graphviz_dep,
                .sub_path = "plugin/dot_layout/gvplugin_dot_layout.c",
            },
        },
    });
    lib_plugin_dot_layout.addIncludePath(graphviz_dep.path("lib"));
    lib_plugin_dot_layout.addIncludePath(graphviz_dep.path("lib/common"));
    lib_plugin_dot_layout.addIncludePath(graphviz_dep.path("lib/pathplan"));
    lib_plugin_dot_layout.addIncludePath(graphviz_dep.path("lib/gvc"));
    lib_plugin_dot_layout.addIncludePath(graphviz_dep.path("lib/cgraph"));
    lib_plugin_dot_layout.addIncludePath(graphviz_dep.path("lib/cdt"));
    lib_plugin_dot_layout.addIncludePath(graphviz_dep.path("lib/cgraph"));
    lib_plugin_dot_layout.addConfigHeader(config_h);
    lib_plugin_dot_layout.linkLibC();
    lib.linkLibrary(lib_plugin_dot_layout);

    const lib_pack = b.addStaticLibrary(.{
        .name = "pack",
        .target = target,
        .optimize = optimize,
    });
    lib_pack.addCSourceFiles(.{
        .root = graphviz_dep.path("lib/pack"),
        .files = &.{ "ccomps.c", "pack.c" },
    });
    lib_pack.addIncludePath(graphviz_dep.path("lib"));
    lib_pack.addIncludePath(graphviz_dep.path("lib/pack"));
    lib_pack.addIncludePath(graphviz_dep.path("lib/cdt"));
    lib_pack.addIncludePath(graphviz_dep.path("lib/gvc"));
    lib_pack.addIncludePath(graphviz_dep.path("lib/pathplan"));
    lib_pack.addIncludePath(graphviz_dep.path("lib/cgraph"));
    lib_pack.addIncludePath(graphviz_dep.path("lib/common"));
    lib_pack.addConfigHeader(config_h);
    lib_pack.linkLibC();
    lib.linkLibrary(lib_pack);

    const lib_label = b.addStaticLibrary(.{
        .name = "label",
        .target = target,
        .optimize = optimize,
    });
    lib_label.addCSourceFiles(.{
        .root = graphviz_dep.path("lib/label"),
        .files = &src_label,
    });
    lib_label.addIncludePath(graphviz_dep.path("lib"));
    lib_label.addIncludePath(graphviz_dep.path("lib/label"));
    lib_label.addIncludePath(graphviz_dep.path("lib/cdt"));
    lib_label.addIncludePath(graphviz_dep.path("lib/gvc"));
    lib_label.addIncludePath(graphviz_dep.path("lib/pathplan"));
    lib_label.addIncludePath(graphviz_dep.path("lib/cgraph"));
    lib_label.addIncludePath(graphviz_dep.path("lib/common"));
    lib_label.addConfigHeader(config_h);
    lib_label.linkLibC();
    lib.linkLibrary(lib_label);

    const lib_plugin_core = b.addStaticLibrary(.{
        .name = "plugin_core",
        .target = target,
        .optimize = optimize,
    });
    lib_plugin_core.addCSourceFiles(.{
        .root = graphviz_dep.path("plugin/core"),
        .files = &src_plugin_core,
    });
    lib_plugin_core.addIncludePath(graphviz_dep.path("lib"));
    lib_plugin_core.addIncludePath(graphviz_dep.path("lib/common"));
    lib_plugin_core.addIncludePath(graphviz_dep.path("lib/pathplan"));
    lib_plugin_core.addIncludePath(graphviz_dep.path("lib/gvc"));
    lib_plugin_core.addIncludePath(graphviz_dep.path("lib/cgraph"));
    lib_plugin_core.addIncludePath(graphviz_dep.path("lib/cdt"));
    lib_plugin_core.addIncludePath(graphviz_dep.path("lib/cgraph"));
    lib_plugin_core.addConfigHeader(config_h);
    lib_plugin_core.linkLibC();
    lib.linkLibrary(lib_plugin_core);

    const expat_dep = b.dependency("libexpat", .{
        .target = target,
        .optimize = optimize,
    });
    lib.linkLibrary(expat_dep.artifact("expat"));

    lib.installHeadersDirectory(graphviz_dep.path("lib"), "", .{});
    lib.installHeadersDirectory(graphviz_dep.path("lib/common"), "", .{});
    lib.installHeadersDirectory(graphviz_dep.path("lib/pathplan"), "", .{});
    lib.installHeadersDirectory(graphviz_dep.path("lib/gvc"), "", .{});
    lib.installHeadersDirectory(graphviz_dep.path("lib/cgraph"), "", .{});
    lib.installHeadersDirectory(graphviz_dep.path("lib/cdt"), "", .{});

    b.installArtifact(lib);

    const exe_mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const exe = b.addExecutable(.{
        .name = "tmp",
        .root_module = exe_mod,
    });
    exe.addIncludePath(.{ .cwd_relative = "src/" });
    exe.addCSourceFile(.{ .file = .{
        .cwd_relative = "src/hello.c",
    } });
    exe.linkLibC();
    exe.linkLibrary(lib);
    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}

const src_cdt = [_][]const u8{
    "dtview.c",  "dtwalk.c",    "dtrestore.c", "dttree.c",    "dtclose.c",
    "dtrenew.c", "dtstrhash.c", "dtflatten.c", "dtextract.c", "dtsize.c",
    "dthash.c",  "dtopen.c",    "dtmethod.c",  "dtstat.c",    "dtdisc.c",
};

const src_cgraph = [_][]const u8{
    "imap.c",    "rec.c",         "subg.c",    "ingraphs.c", "apply.c",
    "agerror.c", "graph.c",       "id.c",      "edge.c",     "utils.c",
    "obj.c",     "unflatten.c",   "acyclic.c", "refstr.c",   "tred.c",
    "node.c",    "node_induce.c", "attr.c",    "write.c",    "io.c",
};

const src_gvc = [_][]const u8{
    "gvtextlayout.c", "gvjobs.c",      "gvlayout.c", "gvplugin.c",
    "gvrender.c",     "gvusershape.c", "gvc.c",      "gvdevice.c",
    "gvconfig.c",     "gvcontext.c",   "gvevent.c",  "gvtool_tred.c",
    "gvloadimage.c",
};

const src_common = [_][]const u8{
    "splines.c",  "htmllex.c", "colxlate.c", "textspan_lut.c", "postproc.c",
    "taper.c",    "globals.c", "timing.c",   "psusershape.c",  "emit.c",
    "textspan.c", "utils.c",   "args.c",     "routespl.c",     "shapes.c",
    "pointset.c", "ns.c",      "ellipse.c",  "arrows.c",       "geom.c",
    "input.c",    "output.c",  "labels.c",   "htmltable.c",
};

const src_util = [_][]const u8{
    "xml.c", "gv_fopen.c", "gv_find_me.c", "random.c", "base64.c",
};

const src_pathplan = [_][]const u8{
    "triang.c", "util.c",  "inpoly.c",  "visibility.c",  "shortest.c",
    "cvt.c",    "route.c", "solvers.c", "shortestpth.c",
};

const src_dotgen = [_][]const u8{
    "dotinit.c",  "class1.c",  "fastgr.c", "cluster.c",    "aspect.c",
    "mincross.c", "acyclic.c", "decomp.c", "dotsplines.c", "compound.c",
    "rank.c",     "class2.c",  "flat.c",   "sameport.c",   "conc.c",
    "position.c",
};

const src_label = [_][]const u8{
    "index.c", "split.q.c", "xlabels.c", "rectangle.c", "node.c",
};

const src_plugin_core = [_][]const u8{
    "gvrender_core_fig.c",  "gvplugin_core.c",
    "gvrender_core_tk.c",   "gvrender_core_ps.c",
    "gvrender_core_map.c",  "gvrender_core_dot.c",
    "gvloadimage_core.c",   "gvrender_core_pic.c",
    "gvrender_core_pov.c",  "gvrender_core_svg.c",
    "gvrender_core_json.c",
};
