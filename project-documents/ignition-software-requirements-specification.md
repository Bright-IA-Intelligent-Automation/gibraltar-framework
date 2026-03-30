# Ignition Software Requirements Specification (SRS)

## Document Control

| Field | Value |
|---|---|
| Company | Bright IA - Intelligent Automation |
| Job Number | JOB#BR26ROB18 |
| Project | Border Wall Finishing System Automation |
| Document Title | Ignition Software Requirements Specification |
| Version | Rev.0 (Draft) |
| Date | 03/23/2026 |
| Author | Bright IA Controls and Software Team |
| Status | Draft for review |

## 1. Purpose

This document defines software requirements for the Ignition SCADA/HMI layer, including dashboards, controls, alarms, historian usage, and KPI calculations for the Border Wall Panel Coating Process.

This specification is intended to remove ambiguity around what the Ignition system must display, control, record, and report.

## 2. Scope for Ignition Developer

In scope:

- Ignition visualization for operations, maintenance, supervision, and management
- HMI controls and command workflows coordinated with PLC/robot systems
- KPI definitions, calculations, and dashboarding
- Alarm and event management
- Historian storage and trend analysis
- User roles, authentication, and audit requirements
- Reporting and daily/shift summaries

Out of scope:

- PLC ladder logic implementation
- Robot path development and tuning
- Mechanical fixture design
- Final paint chemistry tuning

## 3. Reference Context

This SRS aligns with:

- `sow.md` for contractual scope and appendix items
- Known process assumptions for stationary coating recommendation
- Open interface dependencies listed in Appendix B of `sow.md`

## 4. System Overview

The Ignition platform will act as the supervisory layer integrating:

- Painting booth control systems (Bright IA)
- Monorail conveyor signals (Rohner)
- Sandblasting status interface (Gibson)
- Loading/unloading status interface (Rohner)
- Paint system status (with Graco interface details pending)
- Safety and interlock states from PLCs

Primary users:

- Operators
- Line leads/supervisors
- Maintenance technicians
- Engineering/controls staff
- Management stakeholders

## 5. Assumptions and Constraints

- PLC platform standard: Allen-Bradley
- Target throughput basis: 165 panels per 11-hour shift (design support up to 200)
- Coating target: 10-11 mil process target context
- Multiple panel configurations/process options must be supported
- Several interface signal definitions remain pending from external owners

## 6. Functional Requirements

### 6.1 HMI Navigation and Common UI

`FR-HMI-001` Ignition shall provide role-based landing pages for Operator, Supervisor, and Maintenance personas.

`FR-HMI-002` The application shall include global header indicators: line state, safety state, active job, current panel identifier, and communication health.

`FR-HMI-003` The application shall support a site map and one-click navigation to all major areas.

`FR-HMI-004` All pages shall include timestamp, logged-in user, and language selector (English required; Spanish optional `TBD`).

`FR-HMI-005` Color conventions shall be standardized and documented (Run, Idle, Hold, Fault, E-Stop, Manual).

### 6.2 Core Screens

`FR-SCR-001` Overview dashboard shall display end-to-end process status for coating area and upstream/downstream interfaces.

`FR-SCR-002` Painting Booth A and Booth B screens shall display robot readiness, current job, interlocks, and cycle state.

`FR-SCR-003` Paint System screen shall display all paint-ready permissives and quality-critical process values.

`FR-SCR-004` Conveyor/Part Flow screen shall display part arrival, in-position, paint complete, and station clear handshakes.

`FR-SCR-005` Safety screen shall display safety zones, gate/door status, E-stop chain status, and reset conditions.

`FR-SCR-006` Alarm summary and alarm history screens shall be available with filtering by area, priority, and time.

`FR-SCR-007` Trend screens shall provide prebuilt trends for production and paint process variables.

`FR-SCR-008` Manual/maintenance screen shall provide diagnostics and guided recovery views based on permissions.

### 6.3 Control Commands and Interlocks

`FR-CTL-001` Start cycle command shall be available only when all permissives are true.

`FR-CTL-002` Hold/Resume commands shall be supported with clear state indication.

`FR-CTL-003` Station clear / job complete handshake command shall be available per approved sequence.

`FR-CTL-004` Critical commands shall require confirmation dialogs and be audit logged.

`FR-CTL-005` Command ownership (Ignition vs PLC local HMI) shall be configurable per station (`TBD`).

`FR-CTL-006` Recipe/job selection shall support one job number with robot offsets as defined by Bright IA.

### 6.4 Recipe and Job Management

`FR-RCP-001` System shall support job creation/selection with panel type and process offsets.

`FR-RCP-002` Job download status to PLC/robot interfaces shall be visible with success/failure feedback.

`FR-RCP-003` Recipe revision and change history shall be audit logged.

`FR-RCP-004` Unauthorized users shall not modify released recipes.

### 6.5 Alarm and Event Management

`FR-ALM-001` Alarms shall include minimum fields: timestamp, area, tag, priority, message, cause, and recommended action.

`FR-ALM-002` Alarm priorities shall follow defined classes (Critical, High, Medium, Low, Info).

`FR-ALM-003` Acknowledge workflow shall capture user and time.

`FR-ALM-004` Shelving/suppression permissions shall be role-restricted and tracked.

`FR-ALM-005` Alarm KPIs shall include alarm flood count and standing alarm count.

### 6.6 Historian and Data Retention

`FR-HIS-001` Ignition shall historize production, quality, and equipment state tags required for KPI calculations.

`FR-HIS-002` Raw historian resolution and deadbands shall be configured per tag class (fast process, state, summary).

`FR-HIS-003` Minimum retention: 24 months online (`TBD` final retention policy).

`FR-HIS-004` Data export shall support CSV and scheduled report delivery.

### 6.7 Reporting

`FR-RPT-001` Shift report shall include throughput, downtime, defect/rework counts, and alarm summary.

`FR-RPT-002` Daily report shall include booth utilization, cycle time distribution, and top fault causes.

`FR-RPT-003` Weekly report shall include trend comparisons vs production targets.

`FR-RPT-004` Reports shall be printable and exportable (PDF/CSV).

## 7. KPI Specification

### 7.1 KPI Principles

- KPIs must use a single source of truth from approved tags/events
- KPI formulas must be version-controlled
- KPI calculation windows shall support shift/day/week/month

### 7.2 Required KPI List (Initial)

| KPI ID | KPI Name | Definition | Target / Threshold | Data Source | Status |
|---|---|---|---|---|---|
| KPI-001 | Panels Completed per Shift | Count of panels fully processed and released from coating stations | >= 165 per 11-hour shift; design up to 200 | PLC station clear + job complete events | Confirmed |
| KPI-002 | First Pass Yield | Panels completed without rework / total completed | >= 95% (initial target) | Rework event tags, completion events | Proposed |
| KPI-003 | Average Coating Cycle Time | Average elapsed time from part in-position to job complete | Engineering target to be finalized | Part arrival and completion timestamps | Proposed |
| KPI-004 | Rework Rate | Reworked panels / total completed | < 5% target for stationary process | Rework counters | Proposed |
| KPI-005 | Booth Utilization | Runtime in auto / planned available runtime | Target `TBD` | Booth state tags | TBD |
| KPI-006 | Availability | (Planned time - downtime) / planned time | Target `TBD` | Downtime reason model | TBD |
| KPI-007 | Alarm Density | Alarms per hour while running | Threshold `TBD` | Alarm journal | TBD |
| KPI-008 | Paint System Readiness Loss | Time lost due to paint-ready permissives false | Threshold `TBD` | Paint ready permissive tags | TBD |
| KPI-009 | Robot Ready Loss | Time lost due to robot not-ready conditions | Threshold `TBD` | Robot ready/fault tags | TBD |
| KPI-010 | Throughput Forecast vs Plan | Predicted end-of-shift output vs target | >= plan target | Live throughput model | Proposed |
| KPI-011 | Paint Used (Gallons) per Shift | Total mixed paint consumed during shift in gallons | Target `TBD` by panel type | Paint flow totalizers / batch totals | Proposed |
| KPI-012 | Paint Used (Gallons) per Panel | Total gallons consumed divided by completed panels | Target `TBD` by recipe | KPI-011 plus panel completion count | Proposed |
| KPI-013 | Polyurea Component A Usage | Total gallons of Component A consumed | Recipe tolerance `TBD` | Component A flow meter/totalizer | TBD |
| KPI-014 | Polyurea Component B Usage | Total gallons of Component B consumed | Recipe tolerance `TBD` | Component B flow meter/totalizer | TBD |
| KPI-015 | A:B Mix Ratio Deviation | Absolute deviation from required A:B mix ratio over time | Max deviation `TBD` | Component A/B measured usage | TBD |
| KPI-016 | Paint Waste / Purge Volume | Gallons consumed in purge, line flush, and startup waste | Target `TBD` | Purge event tags + flow totals | TBD |
| KPI-017 | Coating Cost per Panel | Coating material cost divided by completed panels | Target `TBD` | Paint usage KPIs + unit material cost | TBD |
| KPI-018 | Downtime by Cause | Minutes lost by categorized reason (robot, paint, conveyor, safety, operator) | Top 3 causes reduced month-over-month | State model + downtime reason codes | Proposed |
| KPI-019 | MTBF (Critical Faults) | Mean runtime between critical production-stopping faults | Target `TBD` | Alarm/event history | Proposed |
| KPI-020 | MTTR (Critical Faults) | Mean time to recover from critical faults | Target `TBD` | Alarm active and clear timestamps | Proposed |
| KPI-021 | Station Clear Response Time | Time from paint complete to station-clear handshake sent | Threshold `TBD` | PLC sequence event timestamps | Proposed |
| KPI-022 | OEE (Line-Level, Coating Scope) | Availability x Performance x Quality across coating operation | Target `TBD` | Availability, throughput, quality KPIs | TBD |

### 7.3 KPI Dashboard Requirements

`FR-KPI-001` Dashboard shall provide real-time KPI tiles with current value, target, and status color.

`FR-KPI-002` Dashboard shall provide trend charts for shift/day/week windows.

`FR-KPI-003` Dashboard shall include drill-down from KPI to underlying events/tags.

`FR-KPI-004` Dashboard shall display planned vs actual production trajectory through shift.

`FR-KPI-005` KPI screens shall display data quality indicator if source tags are stale.

`FR-KPI-006` Paint usage KPIs shall display units in gallons and support optional liters conversion.

`FR-KPI-007` Paint usage KPIs shall support drill-down by booth, recipe, and shift.

## 8. Roles and Access Control

| Role | Capabilities |
|---|---|
| Operator | View process screens, acknowledge alarms, execute permitted cycle commands |
| Supervisor | Operator rights plus job selection, report access, downtime reason review |
| Maintenance | Diagnostics pages, manual recovery tools, maintenance overrides (controlled) |
| Engineer/Admin | Configuration, KPI formula admin, user management, advanced diagnostics |

`FR-SEC-001` Authentication shall be integrated with approved identity source (`TBD`: local AD/IdP).

`FR-SEC-002` Electronic audit trail shall be enabled for command actions, recipe changes, and security changes.

`FR-SEC-003` Session timeout and password policies shall follow Bright IA and client cybersecurity standards.

## 9. Interface Data Requirements

The following interface data packages are mandatory before final deployment:

- PLC I/O list and tag map by subsystem
- Handshake sequence definitions for part in, paint start, paint complete, station clear
- Paint system ready signal list and communication protocol
- Reactor communication mapping and protocol details
- Safety device state and reset logic map

`FR-INT-001` Ignition shall implement interface health monitoring for each external subsystem.

`FR-INT-002` Loss-of-communications alarms shall be generated within 5 seconds of confirmed comm loss (`TBD` final timeout).

## 10. Non-Functional Requirements

`NFR-001` HMI command response (button press to feedback) shall be <= 500 ms under normal load.

`NFR-002` Dashboard page load time shall be <= 2 seconds on operations network clients.

`NFR-003` System availability target shall be >= 99.5% during planned production windows.

`NFR-004` Time synchronization shall use plant-standard NTP across PLCs, Ignition gateway, and clients.

`NFR-005` All production-critical transactions shall be fail-safe on gateway restart.

## 11. Validation and Acceptance Criteria

- FAT: verify all functional requirement IDs using test scripts and witness sign-off
- SAT: verify integrated interfaces and production reporting at site
- KPI validation: reconcile dashboard values with raw historian/event records
- Alarm validation: verify priority, message quality, and acknowledgment workflow

Acceptance requires closure of all Critical and High defects, plus approved workaround plans for any Medium items.

## 12. Open Items Register (Must Be Closed)

| Open Item ID | Description | Owner | Required For |
|---|---|---|---|
| OI-001 | Final HMI page list and visual standard approval | Bright IA + Client | FAT |
| OI-002 | Final KPI target values and thresholds | Gibraltar + Bright IA | FAT |
| OI-003 | Paint system ready signal list from Graco package | Gibraltar | SAT |
| OI-004 | Final interface signal map with Rohner and Gibson | Rohner / Gibson / Bright IA | SAT |
| OI-005 | Final recipe parameter list and offset rules | Bright IA | FAT |
| OI-006 | Final retention policy and report distribution matrix | Gibraltar + Bright IA | SAT |
| OI-007 | Cybersecurity authentication standard (AD/IdP/local) | Gibraltar IT + Bright IA | FAT |
| OI-008 | Confirm paint flow instrumentation and tag mapping for gallons and A:B ratio KPIs | Gibraltar + Graco + Bright IA | FAT |

## 13. Deliverables

- Ignition project with approved HMI/KPI screens
- Tag model and UDT documentation
- Alarm philosophy and alarm list
- KPI formula specification and validation report
- FAT/SAT test records
- Operator and maintenance quick reference guides

## 14. Revision History

| Rev | Date | Description |
|---|---|---|
| Rev.0 | 03/23/2026 | Initial draft created from current project scope and known interface assumptions |
