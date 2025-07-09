#include <gvc.h>
#include <cgraph.h>
#include <stdio.h>
#include <stdlib.h>

extern gvplugin_library_t gvplugin_core_LTX_library;
extern gvplugin_library_t gvplugin_dot_layout_LTX_library;

lt_symlist_t lt_preloaded_symbols[] = {
  { "gvplugin_core_LTX_library", &gvplugin_core_LTX_library },
  { "gvplugin_dot_layout_LTX_library", &gvplugin_dot_layout_LTX_library },
  { 0, 0 }
};

GVC_t *viz_create_context() {
  return gvContextPlugins(lt_preloaded_symbols, 0);
}

int hello() {
  GVC_t *gvc = viz_create_context();
  if (!gvc) {
    fprintf(stderr, "Failed to create GVC context.\n");
    return 1;
  }

static const char dotString[] = "\
digraph {\n\
    compound=true;\n\
    node [shape=Mrecord]\n\
    rankdir=\"LR\"\n\
\n\
    subgraph \"clusterOpen\"\n\
    {\n\
        label = \"Open\"\n\
        \"Assigned\" [label=\"Assigned|exit / OnDeassigned\"];\n\
    }\n\
    \"Deferred\" [label=\"Deferred|entry / Function\"];\n\
    \"Closed\" [label=\"Closed\"];\n\
\n\
    \"OpenNode\" -> \"Assigned\" [style=\"solid\", label=\"Assign / OnAssigned\"];\n\
    \"Assigned\" -> \"Assigned\" [style=\"solid\", label=\"Assign\"];\n\
    \"Assigned\" -> \"Closed\" [style=\"solid\", label=\"Close\"];\n\
    \"Assigned\" -> \"Deferred\" [style=\"solid\", label=\"Defer\"];\n\
    \"Deferred\" -> \"Assigned\" [style=\"solid\", label=\"Assign / OnAssigned\"];\n\
    init [label=\"\", shape=point];\n\
    init -> \"Open\"[style = \"solid\"]\n\
}\n\
";



  Agraph_t *graph = agmemread(dotString);
  if (!graph) {
    fprintf(stderr, "Failed to parse DOT input.\n");
    gvFreeContext(gvc);
    return 3;
  }

  if (gvLayout(gvc, graph, "dot") != 0) {
    fprintf(stderr, "gvLayout failed.\n");
    agclose(graph);
    gvFreeContext(gvc);
    return 4;
  }

  gvRender(gvc, graph, "svg", stderr);

  gvFreeLayout(gvc, graph);
  agclose(graph);
  gvFreeContext(gvc);
  return 0;
}
