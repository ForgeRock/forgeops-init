/*
 * Copyright 2011-2018 ForgeRock AS. All Rights Reserved
 *
 * Use of this code requires a commercial software license with ForgeRock AS.
 * or with one of its affiliates. All use shall be exclusively subject
 * to such license between the licensee and ForgeRock AS.
 */
// A configuration for allowed HTTP requests. Each entry in the configuration contains a pattern
// to match against the incoming request ID and, in the event of a match, the associated roles,
// methods, and actions that are allowed for requests on that particular pattern.
//
// pattern:  A pattern to match against an incoming request's resource ID
// roles:  A comma separated list of allowed roles
// methods:  A comma separated list of allowed methods
// actions:  A comma separated list of allowed actions
// customAuthz: A custom function for additional authorization logic/checks (optional)
// excludePatterns: A comma separated list of patterns to exclude from the pattern match (optional)
//
// A single '*' character indicates all possible values.  With patterns ending in "/*", the "*"
// acts as a wild card to indicate the pattern accepts all resource IDs "below" the specified
// pattern (prefix).  For example the pattern "managed/*" would match "managed/user" or anything
// starting with "managed/".  Note: it would not match "managed", which would need to have its
// own entry in the config.

/*jslint vars:true*/

var httpAccessConfig =
{
    "configs" : [
        // Anyone can read from these endpoints
        {
           "pattern"    : "info/*",
           "roles"      : "*",
           "methods"    : "read",
           "actions"    : "*"
        },
        {
           "pattern"    : "authentication",
           "roles"      : "*",
           "methods"    : "read,action",
           "actions"    : "login,logout"
        },
        {
           "pattern"    : "identityProviders",
           "roles"      : "*",
           "methods"    : "action",
           "actions"    : "getAuthRedirect,handlePostAuth"
        },
        {
           "pattern"    : "identityProviders",
           "roles"      : "openidm-authorized",
           "methods"    : "read",
           "actions"    : "*"
        },
        {
            "pattern"    : "config/ui/themeconfig",
            "roles"      : "*",
            "methods"    : "read",
            "actions"    : "*"
        },
        {
           "pattern"    : "info/uiconfig",
           "roles"      : "*",
           "methods"    : "read",
           "actions"    : "*"
        },
        {
           "pattern"    : "config/selfservice/kbaConfig",
           "roles"      : "*",
           "methods"    : "read",
           "actions"    : "*",
           "customAuthz": "checkIfUIIsEnabled('selfRegistration') || checkIfUIIsEnabled('passwordReset')"
        },
        {
            "pattern"    : "config/ui/dashboard",
            "roles"      : "openidm-authorized",
            "methods"    : "read",
            "actions"    : "*"
        },

        // externally-visible Self-Service endpoints
        {
           "pattern"    : "selfservice/registration",
           "roles"      : "*",
           "methods"    : "read,action",
           "actions"    : "submitRequirements",
           "customAuthz" : "checkIfUIIsEnabled('selfRegistration')"
        },

        {
           "pattern"    : "selfservice/socialUserClaim",
           "roles"      : "*",
           "methods"    : "read,action",
           "actions"    : "submitRequirements",
           "customAuthz" : "checkIfUIIsEnabled('selfRegistration')"
        },

        {
           "pattern"    : "selfservice/reset",
           "roles"      : "*",
           "methods"    : "read,action",
           "actions"    : "submitRequirements",
           "customAuthz" : "checkIfUIIsEnabled('passwordReset')"
        },

        {
           "pattern"    : "selfservice/username",
           "roles"      : "*",
           "methods"    : "read,action",
           "actions"    : "submitRequirements",
           "customAuthz" : "checkIfUIIsEnabled('forgotUsername')"
        },
        {
           "pattern"    : "selfservice/profile",
           "roles"      : "*",
           "methods"    : "read,action",
           "actions"    : "submitRequirements"
        },
        {
           "pattern"    : "selfservice/termsAndConditions",
           "roles"      : "*",
           "methods"    : "read,action",
           "actions"    : "submitRequirements"
        },
        {
           "pattern"    : "selfservice/kbaUpdate",
           "roles"      : "*",
           "methods"    : "read,action",
           "actions"    : "submitRequirements"
        },

        // self-service is allowed to call the policy service to validate any route
        {
            "pattern"   : "policy/*",
            "roles"     : "*",
            "methods"   : "action",
            "actions"   : "validateObject",
            "customAuthz" : "context.current.name === 'selfservice'"
        },

        // anonymous users are allowed to evaluate policy only via the selfservice endpoints
        {
            "pattern"   : "policy/selfservice/registration",
            "roles"     : "*",
            "methods"   : "action,read",
            "actions"   : "validateObject",
            "customAuthz" : "checkIfUIIsEnabled('selfRegistration')"
        },

        {
            "pattern"   : "policy/selfservice/reset",
            "roles"     : "*",
            "methods"   : "action,read",
            "actions"   : "validateObject",
            "customAuthz" : "checkIfUIIsEnabled('passwordReset')"
        },

        {
           "pattern"    : "selfservice/kba",
           "roles"      : "openidm-authorized",
           "methods"    : "read",
           "actions"    : "*",
           "customAuthz" : "checkIfUIIsEnabled('kbaEnabled')"
        },

        // rules governing requests originating from forgerock-selfservice
        {
            "pattern"   : "managed/user",
            "roles"     : "openidm-reg",
            "methods"   : "create",
            "actions"   : "*",
            "customAuthz" : "checkIfUIIsEnabled('selfRegistration') && isSelfServiceRequest() && onlyEditableManagedObjectProperties('user', [])"
        },
        {
            "pattern"   : "managed/user",
            "roles"     : "*",
            "methods"   : "query",
            "actions"   : "*",
            "customAuthz" : "(checkIfUIIsEnabled('selfRegistration') || checkIfUIIsEnabled('forgotUsername') || checkIfUIIsEnabled('passwordReset')) && isSelfServiceRequest()"
        },
        {
            "pattern"   : "managed/user/*",
            "roles"     : "*",
            "methods"   : "read",
            "actions"   : "*",
            "customAuthz" : "(checkIfUIIsEnabled('forgotUsername') || checkIfUIIsEnabled('passwordReset')) && isSelfServiceRequest()"
        },
        {
            "pattern"   : "managed/user/*",
            "roles"     : "*",
            "methods"   : "patch,action",
            "actions"   : "patch",
            "customAuthz" : "(checkIfUIIsEnabled('selfRegistration') || checkIfUIIsEnabled('passwordReset') || checkIfProgressiveProfileIsEnabled()) && isSelfServiceRequest() && onlyEditableManagedObjectProperties('user', [])"
        },
        {
            "pattern"   : "external/email",
            "roles"     : "*",
            "methods"   : "action",
            "actions"   : "send",
            "customAuthz" : "(checkIfUIIsEnabled('forgotUsername') || checkIfUIIsEnabled('passwordReset') || checkIfUIIsEnabled('selfRegistration')) && isSelfServiceRequest()"
        },

        // Schema service that provides sanitized schema data needed to support the UI
        {
            "pattern"    : "schema/*",
            "roles"      : "openidm-authorized,openidm-authenticated",
            "methods"    : "read",
            "actions"    : "*"
        },

        // Consent service that provides end-user functions related to Privacy & Consent
        {
            "pattern"    : "consent",
            "roles"      : "openidm-authorized",
            "methods"    : "action",
            "actions"    : "*"
        },

        // openidm-admin can request nearly anything (except query expressions on repo endpoints)
        {
            "pattern"   : "*",
            "roles"     : "openidm-admin",
            "methods"   : "*", // default to all methods allowed
            "actions"   : "*", // default to all actions allowed
            "customAuthz" : "disallowQueryExpression()",
            "excludePatterns": "repo,repo/*"
        },
        // additional rules for openidm-admin that selectively enable certain parts of system/
        {
            "pattern"   : "system/*",
            "roles"     : "openidm-admin",
            "methods"   : "create,read,update,delete,patch,query", // restrictions on 'action'
            "actions"   : "",
            "customAuthz" : "disallowQueryExpression()"
        },
        // Allow access to custom scripted endpoints
        {
            "pattern"   : "system/*",
            "roles"     : "openidm-admin",
            "methods"   : "script",
            "actions"   : "*"
        },
        // Note that these actions are available directly on system as well
        {
            "pattern"   : "system/*",
            "roles"     : "openidm-admin",
            "methods"   : "action",
            "actions"   : "test,testConfig,createconfiguration,liveSync,authenticate"
        },
        // Disallow command action on repo
        {
            "pattern"   : "repo",
            "roles"     : "openidm-admin",
            "methods"   : "*", // default to all methods allowed
            "actions"   : "*", // default to all actions allowed
            "customAuthz" : "disallowCommandAction()"
        },
        {
            "pattern"   : "repo/*",
            "roles"     : "openidm-admin",
            "methods"   : "*", // default to all methods allowed
            "actions"   : "*", // default to all actions allowed
            "customAuthz" : "disallowCommandAction()"
        },
        //allow the ability to delete links for a specific mapping
        {
            "pattern"   : "repo/link",
            "roles"     : "openidm-admin",
            "methods"   : "action",
            "actions"   : "command",
            "customAuthz" : "request.additionalParameters.commandId === 'delete-mapping-links'"
        },

        // Additional checks for authenticated users
        {
            "pattern"   : "policy/*",
            "roles"     : "openidm-authorized", // openidm-authorized is logged-in users
            "methods"   : "read,action",
            "actions"   : "*"
        },
        {
            "pattern"   : "config/ui/*",
            "roles"     : "openidm-authorized",
            "methods"   : "read",
            "actions"   : "*"
        },
        {
            "pattern"   : "authentication",
            "roles"     : "openidm-authorized",
            "methods"   : "action",
            "actions"   : "reauthenticate"
        },

        // This rule is primarily controlled by the ownDataOnly function - that will only allow
        // access to the endpoint from which the user originates
        // (For example a managed/user with the _id of bob will only be able to access managed/user/bob)

        {
            "pattern"   : "*",
            "roles"     : "openidm-authorized",
            "methods"   : "read,action,delete",
            "actions"   : "bind,unbind",
            "customAuthz" : "ownDataOnly()"
        },
        {
            "pattern"   : "*",
            "roles"     : "openidm-authorized",
            "methods"   : "update,patch,action",
            "actions"   : "patch",
            "customAuthz" : "ownDataOnly() && onlyEditableManagedObjectProperties('user', []) && reauthIfProtectedAttributeChange()"
        },
        {
            "pattern"   : "selfservice/user/*",
            "roles"     : "openidm-authorized",
            "methods"   : "patch,action",
            "actions"   : "patch",
            "customAuthz" : "(request.resourcePath === 'selfservice/user/' + context.security.authorization.id) && onlyEditableManagedObjectProperties('user', [])"
        },

        // enforcement of which notifications you can read and delete is done within the endpoint
        {
            "pattern"   : "endpoint/usernotifications",
            "roles"     : "openidm-authorized",
            "methods"   : "read",
            "actions"   : "*"
        },
        {
            "pattern"   : "endpoint/usernotifications/*",
            "roles"     : "openidm-authorized",
            "methods"   : "delete",
            "actions"   : "*"
        },

        // Workflow-related endpoints for authorized users

        {
            "pattern"   : "endpoint/getprocessesforuser",
            "roles"     : "openidm-authorized",
            "methods"   : "read",
            "actions"   : "*"
        },
        {
            "pattern"   : "endpoint/gettasksview",
            "roles"     : "openidm-authorized",
            "methods"   : "query",
            "actions"   : "*"
        },
        {
            "pattern"   : "workflow/taskinstance/*",
            "roles"     : "openidm-authorized",
            "methods"   : "action",
            "actions"   : "complete",
            "customAuthz" : "isMyTask()"
        },
        {
            "pattern"   : "workflow/taskinstance/*",
            "roles"     : "openidm-authorized",
            "methods"   : "read,update",
            "actions"   : "*",
            "customAuthz" : "canUpdateTask()"
        },
        {
            "pattern"   : "workflow/processinstance",
            "roles"     : "openidm-authorized",
            "methods"   : "create",
            "actions"   : "*",
            "customAuthz": "isAllowedToStartProcess()"
        },
        {
            "pattern"   : "workflow/processdefinition/*",
            "roles"     : "openidm-authorized",
            "methods"   : "*",
            "actions"   : "read",
            "customAuthz": "isOneOfMyWorkflows()"
        },
        // Clients authenticated via SSL mutual authentication
        {
            "pattern"   : "managed/user",
            "roles"     : "openidm-cert",
            "methods"   : "patch,action",
            "actions"   : "patch",
            "customAuthz" : "isQueryOneOf({'managed/user': ['for-userName']}) && restrictPatchToFields(['password'])"
        }
    ]
};

// Additional custom authorization functions go here
