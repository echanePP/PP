=====================================================================
 STEP 1 — App > Formulas
 Paste everything between the lines. Do this BEFORE pasting the YAML,
 or every colour reference in the screen will show as an error.
=====================================================================

clrInk        = RGBA(15, 23, 42, 1);
clrMuted      = RGBA(100, 116, 139, 1);
clrLine       = RGBA(226, 232, 240, 1);
clrPage       = RGBA(248, 250, 252, 1);
clrSurface    = RGBA(255, 255, 255, 1);

clrViolet     = RGBA(124, 58, 237, 1);
clrVioletDeep = RGBA(76, 29, 149, 1);
clrVioletSoft = RGBA(167, 139, 250, 1);
clrVioletTint = RGBA(245, 243, 255, 1);

clrAmber      = RGBA(245, 158, 11, 1);
clrAmberTint  = RGBA(255, 251, 235, 1);
clrRed        = RGBA(220, 38, 38, 1);
clrRedTint    = RGBA(254, 242, 242, 1);

szCard        = 880;
szCardX       = 243;


=====================================================================
 STEP 2 — App > OnStart
=====================================================================

Set(varState, "idle");
Set(varError, "");
Set(varStep, 1);
Set(varSiteTitle, "");
Set(varFileUrl, "");
Set(varGroups, "");
Set(varOwnersGroup, "");
Set(varMembersGroup, "");
Set(varVisitorsGroup, "");
ClearCollect(
    colAll,
    FirstN(
        Table(
            {
                Group: "",
                Title: "",
                Email: "",
                Role: "",
                MemberType: ""
            }
        ),
        0
    )
);
Set(varRes, Blank())


=====================================================================
 STEP 3 — add the flow
=====================================================================

 Power Automate > Add flow > GetSiteGroupsApp

 The flow must expose three text inputs in this order:
   1  SiteUrl
   2  RequesterEmail
   3  Groups

 and return five text outputs:
   status, message, payload, siteTitle, fileUrl


=====================================================================
 STEP 4 — paste SPGroupExporter.pa.yaml
=====================================================================

 Tree view > select the screen > Ctrl+V, or use the
 "Paste from clipboard" option on the screen node.
