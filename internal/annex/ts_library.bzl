

TsOutput = provider(fields = ["declarations"])

def ts_library_impl(ctx):
    print("ts_library_impl")
    # Run TSC with the given tsconfig.
    # overrriding to
    #   "declaration": true,
    #   "emitDeclarationOnly": true,
    #   "isolatedModules": false,
    # and return the dts files

    return [TsOutput(declarations = depset())]




ts_library = rule(
    implementation = ts_library_impl,
    attrs = {
        "srcs": attr.label_list(
            doc = "The TypeScript source files to compile.",
            allow_files = [".ts", ".tsx"],
            mandatory = True,
        ),
        "deps": attr.label_list(),
        # "tsconfig": attr.label(
        #     allow_single_file = True,
        # ),
    },
    provides = [TsOutput],
)