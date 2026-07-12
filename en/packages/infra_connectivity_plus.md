# infra_connectivity_plus

Infrastructure package implementing `NetworkInfo` contract from `app_core` using `connectivity_plus`.

&nbsp;

## Purpose

This package provides implementation for:

- checking whether device has network interface
- checking Wi-Fi connectivity
- verifying internet reachability

Contract stays in `app_core`, technology implementation stays in this package.

&nbsp;

## Implements

- `NetworkInfo`

&nbsp;

## Dependencies

- app_core
- connectivity_plus

&nbsp;

## Responsibilities

- read device connectivity status
- check Wi-Fi connectivity
- perform internet reachability checks

&nbsp;

## Notes

This package only handles connectivity information.

It is not a network client and does not perform HTTP requests.
