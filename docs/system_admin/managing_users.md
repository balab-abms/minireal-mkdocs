---
title: System Administraion - Managing User Accounts
summary: Clarification on the actions system admins can take to manage user accounts.
authors:
    - Duguma Yeshitla
date: 2024-11-15
---

# Managing User Accounts
The MiniReal system provides special features for users with the role of `OWNER`
and `ADMIN`. The type of user roles and their privialge is shown in the following table. 

## User Roles and Permissions

| **Role**   | **Description**     | **ABMS Project**       | **Sample Models**      | **User Management**               |
|------------|---------------------|-------------------------|-----------------------|------------------------------|
| **Owner**  | The user who deploys the web service onto an HPC resource. This role has all system privileges for maintenance and management. | generation, running  | upload, download    | update profile, create owner, create admin, create user |
| **Admin**  | Users who manage samples and other users. This role is one level below the Owner.   | generation, running     | upload, download      | update profile, create user   |
| **User**   | Normal users who run their models on the web service.      | generation, running     | download        | update profile      |

!!! note
    The defintioin of `System administrator` is given to users with the role
    of `OWNER` and `ADMIN`.

## Viewing List of Users
System administrator users can view the list of users registerd on the system by navigating to
the `Users List` page. This page can be reached to by selecting the `Users List`
option from the `Admin` dropdown found at the navigation bar.
![List of Users](../imgs/user_creation_options.png){ align=center }
<p style="text-align: center; font-size: 0.75em;">
    Figure: List of Users page
</p>

## Creating New Users
System adminstrators can create other users with the privilage they have.
Creating new users is possible by filling out the necessary information on the `Add User`
page. This page can be reached through two ways through two ways.

1. It can be done by selecting the `Add User` option from the `Admin` dropdown found
at the navigation bar.
2. Navigate to the `Users List` page. Then from this page clicking on the `Add User` 
button will display the form to create a new user account.

![User Creation Page](../imgs/user_creation_page.png){ align=center }
<p style="text-align: center; font-size: 0.75em;">
    Figure: Add User page
</p>

The information required to register a new user is:

* username
* name
* password
* confirming the password
* role

!!! warning
    Newly created users should change their password on an initial login since
    the initial password is created by System adminstrators.

## Reseting Password for Users
!!! note
    The action of resting in this context is defined as changing an existing password to a new one.
    System administrator users won't be able to view any password, but can change it when someone
    forgets thier password.

To reset the password for a user, system adminstrators can click on the reset icon
for the respective user on the table found on the `Users List` page. A dialog will pop-up
to request for a new password.

![Reset password Dialog](../imgs/user_pwd_reset_dialog.png){ align=center }
<p style="text-align: center; font-size: 0.75em;">
    Figure: User password reset dialog
</p>

## Deleting User Accounts
System administrators can delete user accounts by clicking on the delete icon for 
the respective user from the users list table found on the `Users List` page. This
will invoke a confirmation dialog to ensure that the deletion action is intended.
![User deletion confirmation dialog](../imgs/user_del_confirm_dialog.png){ align=center }
<p style="text-align: center; font-size: 0.75em;">
    Figure: User deletion confirmation dialog
</p>

!!! note
    Users with the `ADMIN` role can add, delete or reset password to users with `USER`
    role only.
    
    However users with the `OWNER` role can add, delete or reset password for all types
    of user roles.