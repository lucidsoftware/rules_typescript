# This file is to create some hypothetical runtime tool.
# This is to be an example consumer of the emitted JavaScript from the TypeScript Compiler.
# Rollup, Webpack, Closure are all examples of this.

load(":ts_library.bzl", "TsOutput")
load(":runtime.bzl", "transpile_ts_to_js")


RUNTIME_FIELDS = ["js_files"]

CommonJsEs3 = provider(fields = RUNTIME_FIELDS)

def fake_runtime_aspect_impl(target, ctx):
    print("fake_runtime_aspect_impl")
    print(ctx.rule.files.srcs)
    outputs = []
    label = target.label
    workspace_segments = label.workspace_root.split("/") if label.workspace_root else []
    package_segments = label.package.split("/") if label.package else []
    trim = len(workspace_segments) + len(package_segments)
    outputs = transpile_ts_to_js(ctx, trim, ".es3", {})
    # run ts.transpileModule
    return [CommonJsEs3(js_files = outputs)]



fake_runtime_aspect = aspect(
    implementation = fake_runtime_aspect_impl,
    attr_aspects = ["deps"],
    # required_aspect_providers = [[TsOutput]],
    provides = [CommonJsEs3],
    attrs = {
        "_compiler": attr.label(
            default = "//internal:tsc",
            executable = True,
            cfg = "host",
        ),
    },
)


def fake_runtime_impl(ctx):
    print("fake_runtime_impl")
    print(ctx.attr.ts_deps)
    outputs = []
    for dep in ctx.attr.ts_deps:
        outputs += [dep for dep in dep[CommonJsEs3].js_files]
    # print(ctx.attrs.ts_deps)
    return [DefaultInfo(files = depset(outputs))]


fake_runtime = rule(
    implementation = fake_runtime_impl,
    attrs = {
        "ts_deps": attr.label_list(aspects = [fake_runtime_aspect], providers = [TsOutput, CommonJsEs3])
    },
)


# def runtimeFactory(tsconfig, suffix, provider):
#     def _implementation(target, ctx):
#         print("fake_runtime_aspect_impl")
#         print(tsconfig)
#         print(suffix)
#         return [provider(js_files = depset())]

#     return aspect(
#     implementation = _implementation,
#     attr_aspects = ["deps"],
#     required_aspect_providers = [[provider]],
# )