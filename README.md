# sles-chef

# PLEASE NOTE: Although this cookbook will build Chef's product stack on SLES12SP1, it is not a generally supported platform for our server products. Use at your own risk.

You should run our products on an Enterprise Linux variant (CentOS, or Redhat) or Ubuntu server.

To accomplish this, *you're going to need to read the usage section carefully.*

With that said, this cookbook will build a Chef stack (currently a Chef server, with reporting, manage, and push jobs server, and an Automate server, with Workflow and Visibility) using SLES 12 SP1. This is a Chef provisioning cookbook.

TODO:
- Add build nodes for Workflow.
- Add Compliance.
- Allow 'tier' architecture.
- Configure data collector on chef server to emit to Visibility.
- Add Chef provisioning SSH support.

## Supported Platforms

### Tested And Validated On
- SLES 12 SP1

## Usage

Put a license file in files/default/delivery.license. May I suggest getting a trial license if you're just trying this out?

I have a local vagrant box I build from the Bento project and call bento/sles12sp1. Since SLES is licensed you'll need your own SLES box to point at. If you don't want to use Vagrant to build this I've included an AWS provider, and you could also look at Chef provisioning Azure.

My focus will be on Chef provisioning SSH next as it can be cloud agnostic.

Run `rake up` from the cookbook directory.
