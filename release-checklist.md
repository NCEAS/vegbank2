# Vegbank Release Checklist Template

When testing is complete on the develop branch, create a new issue containing the following checklist. Then, follow the steps to prepare and publish the release.
    
- [ ] Create a branch named `task-<this-issue-#>-<version-tag>-release-prep`, and push the following changes:
  - [ ] **pyproject.toml & uv.lock**: Update the VegBank version number in `pyproject.toml`, and [install dependencies using uv](README.md#installing-vegbank-locally), in order to update the `uv.lock` file (since this also contains the vegbank version number). Commit both.
  - [ ] **Chart.yaml**: Update chart `version` and `appVersion`
  - _(IGNORE FOR PATCH RELEASES)_: `README.md`:
    - [ ] Update release number
    - [ ] Add new DOI and citation for this release
  - [ ] PR & merge release prep branch to `develop`
- [ ] PR & merge `develop` -> `main`
- [ ] [Build and push docker image](./docker/README.md#step-3-build--push-your-image)
- [ ] [Package and push helm chart](./helm/README.md#packaging-and-publishing-the-helm-chart)
- [ ] install the new helm chart in dev, and confirm it works as expected
- [ ] Tag the release:

    ```shell
      # get the git sha
      git rev-parse --short HEAD

      # tag the api code release
      git tag x.x.x <commit-sha>

      # tag the helm chart release
      git tag chart-x.x.x <commit-sha>

      # IMPORTANT - DON'T FORGET THIS!
      git push --tags
    ```

- _(IGNORE FOR PATCH RELEASES)_: Add the metadata for the reserved DOI and publish it with the correct softwareheritage url
- [ ] Add to GH `Releases` page and announce as appropriate
