# kzdiff

kzdiff is an easy diff tool for Kustomize. This command compares with its remote default branch.

# usage
Usage: kzdiff <kustomize-path> [options...]

Options:
  -b, --branch <ref>       Remote branch or commit to compare against
  -r, --ref <ref>          Same as -b/--branch (default: auto-detect)
  -h, --help               Show this help message
  -v, --verbose            Enable verbose debug logging
  --version                Show version number
  --                       Pass remaining arguments to kustomize

Examples:
  kzdiff ./examples/overlays/prod
  kzdiff ./examples/overlays/prod -b develop
  kzdiff ./examples/overlays/prod -r b44e5dcad7aa15e023eb09f24a5b9b968cc46e13
  kzdiff ./examples/overlays/prod -- --enable-helm
  kzdiff ./examples/overlays/prod -b staging -- --enable-helm
