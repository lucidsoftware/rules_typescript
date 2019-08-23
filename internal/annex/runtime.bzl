
def transpile_ts_to_js(ctx, trim, suffix, ts_config_overrides):
    print('transpile_ts_to_js')
    # call ts.transpileModule, but add `suffix` into file name before `.js`
    # a runtime aspect doesn't have to use this function, it is just here to help.
    outputs = []
    for ts_source in ctx.rule.files.srcs:
        basename = "/".join(ts_source.short_path.split("/")[trim:])
        for ext in [".tsx", ".ts"]:
            if basename.endswith(ext):
                basename = basename[:-len(ext)]
                break
        outputs += [ctx.actions.declare_file(basename + suffix + ".js")]

    # ctx.actions.run

    return outputs

