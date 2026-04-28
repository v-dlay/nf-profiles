params.use_alpha = false
params.use_beta  = false
params.use_gamma = false
params.outdir    = 'results/default'

process VERIFY_PROFILES {
    debug true
    publishDir params.outdir, mode: 'copy'

    output:
    path 'profile_report.txt'

    script:
    def active = []
    if (params.use_alpha) active << 'alpha'
    if (params.use_beta)  active << 'beta'
    if (params.use_gamma) active << 'gamma'
    def summary = active ? active.join(', ') : 'none (default only)'
    """
    {
    echo "=============================="
    echo "Active profiles : ${summary}"
    echo "------------------------------"
    echo "use_alpha : ${params.use_alpha}"
    echo "use_beta  : ${params.use_beta}"
    echo "use_gamma : ${params.use_gamma}"
    echo "outdir    : ${params.outdir}"
    echo "=============================="
    } | tee profile_report.txt
    """
}

workflow {
    def logMsg = """
    ==============================
    N F - P R O F I L E S
    ==============================
    use_alpha : ${params.use_alpha}
    use_beta  : ${params.use_beta}
    use_gamma : ${params.use_gamma}
    outdir    : ${params.outdir}
    ==============================
    """.stripIndent()

    log.info logMsg

    def logDir = new File("${params.outdir}/logs")
    logDir.mkdirs()
    new File("${logDir}/pipeline.log") << logMsg

    VERIFY_PROFILES()
}
