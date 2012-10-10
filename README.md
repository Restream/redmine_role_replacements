# Redmine role replacement plugin

Redmine plugin for per-project role replacement.

## Installation

Follow the plugin installation procedure at http://www.redmine.org/wiki/redmine/Plugins.

## Usage

The Role Shift plugin adds new project permission "Manage role replacements". This pemission should be enabled for roles which you want to control role shifts. By default only admins can manage project role shifts.

You also need to enable the "Role Replacements" module for projects you want to configure.
If you have "Manage role replacements" permission you will see new "Role replacements" tab in project.

Under this tab you can add, edit and remove role replacements for the project.

> For creating a role replacement you need to have a role permissions of which will be used to replace permissions of basic role. It is a good idea to create a special role for this.

For private projects, prohibits replacement of Anonymous and NonMember roles. For example, you can replace roles of Reporter or Developer, but you can not replace the role of NonMember to Developer.

Public projects allow any kind of replacements.

Result of role replacements:

<table>
  <tr>
    <th colspan="3"></th>
    <th colspan="3">Role after</th>
  </tr>
  <tr>
    <th colspan="3"></th>
    <th>Anonymous</th>
    <th>NonMember</th>
    <th>Member</th>
  </tr>
  <tr>
    <th rowspan="6">Role before</th>
    <th rowspan="3">Private project</th>
    <th>Anonymous</th>
    <td>N/A</td>
    <td>N/A</td>
    <td>N/A</td>
  </tr>
  <tr>
    <th>NonMember</th>
    <td>N/A</td>
    <td>N/A</td>
    <td>N/A</td>
  </tr>
  <tr>
    <th>Member</th>
    <td>N/A</td>
    <td>N/A</td>
    <td>LJV</td>
  </tr>
  <tr>
    <th rowspan="3">Public project</th>
    <th>Anonymous</th>
    <td>N/A</td>
    <td>LV</td>
    <td>LV</td>
  </tr>
  <tr>
    <th>NonMember</th>
    <td>LV</td>
    <td>N/A</td>
    <td>LV</td>
  </tr>
  <tr>
    <th>Member</th>
    <td>LJV</td>
    <td>LJV</td>
    <td>LJV</td>
  </tr>
</table>

* N/A - replacement is not valid and don't be applied
* L - project visible in projects list
* J - project visible in jump box
* V - access to project according role_after permissions

## Testing

rake test:plugins:all RAILS_ENV=test PLUGIN=redmine_role_replacements
