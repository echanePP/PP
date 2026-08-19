# =====================================================================
#  SP GROUP EXPORTER  —  Canvas App YAML
#  Paste screen block into App Studio (Edit > Paste) after adding
#  App.Formulas and App.OnStart below.
#
#  Target: Tablet layout, 1366 x 768
#  Flow:   GetSiteGroupsApp  (Power Apps V2 trigger, 3 text inputs)
# =====================================================================


# ---------------------------------------------------------------------
#  APP.FORMULAS  —  paste into App > Formulas
#  Named formulas so every color/size lives in exactly one place.
# ---------------------------------------------------------------------
#
#  clrInk        = RGBA(15, 23, 42, 1);        // headings
#  clrMuted      = RGBA(100, 116, 139, 1);     // secondary text
#  clrLine       = RGBA(226, 232, 240, 1);     // hairlines
#  clrPage       = RGBA(248, 250, 252, 1);     // canvas
#  clrSurface    = RGBA(255, 255, 255, 1);     // card
#
#  clrViolet     = RGBA(124, 58, 237, 1);      // primary
#  clrVioletDeep = RGBA(76, 29, 149, 1);       // header / pressed
#  clrVioletSoft = RGBA(167, 139, 250, 1);     // accent line
#  clrVioletTint = RGBA(245, 243, 255, 1);     // selected card fill
#
#  clrAmber      = RGBA(245, 158, 11, 1);      // notice
#  clrAmberTint  = RGBA(255, 251, 235, 1);
#  clrGreen      = RGBA(16, 185, 129, 1);      // success
#  clrRed        = RGBA(220, 38, 38, 1);       // error
#  clrRedTint    = RGBA(254, 242, 242, 1);
#
#  szCard        = 880;
#  szCardX       = 243;
#  radLg         = 16;
#  radMd         = 10;
#
#  // Hex strings for SVG interpolation (SVG can't read RGBA())
#  hexViolet     = "%237C3AED";
#  hexVioletDeep = "%234C1D95";
#  hexWhite      = "%23FFFFFF";
#  hexMuted      = "%2364748B";
#  hexAmber      = "%23F59E0B";
#  hexGreen      = "%2310B981";
#  hexRed        = "%23DC2626";
#
#  // Loading step copy — cycled by tmrSpin
#  tblSteps =
#      Table(
#          { Idx: 1, Msg: "Checking the site address",   Sub: "Confirming the site exists" },
#          { Idx: 2, Msg: "Verifying your access",       Sub: "Looking you up in site collection admins" },
#          { Idx: 3, Msg: "Reading group membership",    Sub: "Owners, members and visitors" },
#          { Idx: 4, Msg: "Building your export",        Sub: "Almost there" }
#      );


# ---------------------------------------------------------------------
#  APP.ONSTART
# ---------------------------------------------------------------------
#
#  Set(varState, "idle");
#  Set(varError, "");
#  Set(varStep, 1);
#  Set(varSiteTitle, "");
#  Set(varFileUrl, "");
#  Set(varOwnersGroup, "");
#  Set(varMembersGroup, "");
#  Set(varVisitorsGroup, "");
#  ClearCollect(
#      colAll,
#      FirstN(
#          AddColumns(
#              Table({ Seed: "" }),
#              Group,      "",
#              Title,      "",
#              Email,      "",
#              Role,       "",
#              MemberType, ""
#          ),
#          0
#      )
#  );


# =====================================================================
#  SCREEN
# =====================================================================
- scrHome:
    Control: Screen
    Properties:
      Fill: =clrPage
      LoadingSpinner: =LoadingSpinner.None
    Children:

      # -------------------------------------------------------------
      #  HEADER BAR
      # -------------------------------------------------------------
      - recHeaderBase:
          Control: Rectangle
          Properties:
            X: =0
            Y: =0
            Width: =Parent.Width
            Height: =84
            Fill: =clrVioletDeep

      - recHeaderWash:
          Control: Rectangle
          Properties:
            X: =0
            Y: =0
            Width: =Parent.Width
            Height: =84
            Fill: =RGBA(124, 58, 237, 0.55)

      - recHeaderEdge:
          Control: Rectangle
          Properties:
            X: =0
            Y: =81
            Width: =Parent.Width
            Height: =3
            Fill: =clrVioletSoft

      - imgBrandMark:
          Control: Image
          Properties:
            X: =36
            Y: =26
            Width: =32
            Height: =32
            Image: |
              ="data:image/svg+xml;utf8, " & EncodeUrl(
                "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 32 32' fill='none'>
                   <rect x='2' y='2' width='28' height='28' rx='9' fill='#FFFFFF' fill-opacity='0.16'/>
                   <path d='M16 8.5 L23 16 L16 23.5 L9 16 Z' fill='#FFFFFF' fill-opacity='0.95'/>
                   <path d='M16 12.5 L19.5 16 L16 19.5 L12.5 16 Z' fill='#7C3AED'/>
                 </svg>")

      - lblBrand:
          Control: Label
          Properties:
            X: =82
            Y: =28
            Width: =360
            Height: =28
            Text: ="SP Group Exporter"
            Color: =RGBA(255, 255, 255, 1)
            Size: =15
            FontWeight: =FontWeight.Semibold
            Font: =Font.'Segoe UI'

      - lblEnv:
          Control: Label
          Properties:
            X: =Parent.Width - 300
            Y: =30
            Width: =264
            Height: =24
            Text: =User().Email
            Color: =RGBA(255, 255, 255, 0.75)
            Size: =11
            Align: =Align.Right
            Font: =Font.'Segoe UI'

      # -------------------------------------------------------------
      #  MAIN CARD
      # -------------------------------------------------------------
      - recCardShadow:
          Control: Rectangle
          Properties:
            X: =szCardX - 2
            Y: =126
            Width: =szCard + 4
            Height: =530
            Fill: =RGBA(76, 29, 149, 0.07)

      - recCard:
          Control: Rectangle
          Properties:
            X: =szCardX
            Y: =122
            Width: =szCard
            Height: =530
            Fill: =clrSurface
            BorderColor: =clrLine
            BorderThickness: =1

      - recCardAccent:
          Control: Rectangle
          Properties:
            X: =szCardX
            Y: =122
            Width: =szCard
            Height: =4
            Fill: =clrViolet

      # ---------------- Card header ----------------
      - imgSharePoint:
          Control: Image
          Properties:
            X: =szCardX + 40
            Y: =162
            Width: =56
            Height: =56
            Image: |
              ="data:image/svg+xml;utf8, " & EncodeUrl(
                "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 56 56' fill='none'>
                   <circle cx='21' cy='20' r='13' fill='#036C70'/>
                   <circle cx='34' cy='24' r='12' fill='#1A9BA1'/>
                   <circle cx='31' cy='38' r='9' fill='#37C6D0'/>
                   <rect x='8' y='19' width='22' height='22' rx='3' fill='#03787C'/>
                   <text x='19' y='35' font-family='Segoe UI, sans-serif' font-size='16'
                         font-weight='600' fill='#FFFFFF' text-anchor='middle'>S</text>
                 </svg>")

      - lblTitle:
          Control: Label
          Properties:
            X: =szCardX + 112
            Y: =158
            Width: =620
            Height: =40
            Text: ="Export SharePoint group users"
            Color: =clrInk
            Size: =25
            FontWeight: =FontWeight.Semibold
            Font: =Font.'Segoe UI'

      - lblSubtitle:
          Control: Label
          Properties:
            X: =szCardX + 112
            Y: =198
            Width: =620
            Height: =44
            Text: |
              ="Enter a site address, choose the groups to include, and generate the export in one step."
            Color: =clrMuted
            Size: =12
            Font: =Font.'Segoe UI'

      # ---------------- SCA notice ----------------
      - recNotice:
          Control: Rectangle
          Properties:
            X: =szCardX + 40
            Y: =252
            Width: =szCard - 80
            Height: =52
            Fill: =clrAmberTint
            BorderColor: =RGBA(245, 158, 11, 0.35)
            BorderThickness: =1

      - recNoticeBar:
          Control: Rectangle
          Properties:
            X: =szCardX + 40
            Y: =252
            Width: =4
            Height: =52
            Fill: =clrAmber

      - imgNotice:
          Control: Image
          Properties:
            X: =szCardX + 60
            Y: =268
            Width: =20
            Height: =20
            Image: |
              ="data:image/svg+xml;utf8, " & EncodeUrl(
                "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none'
                      stroke='#B45309' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'>
                   <path d='M12 3l8 4v5c0 4.5-3.2 8.3-8 9.5C7.2 20.3 4 16.5 4 12V7l8-4z'/>
                   <path d='M12 9v4'/><circle cx='12' cy='16.2' r='0.9' fill='#B45309' stroke='none'/>
                 </svg>")

      - lblNotice:
          Control: Label
          Properties:
            X: =szCardX + 90
            Y: =264
            Width: =szCard - 150
            Height: =32
            Text: |
              ="Make sure you're added as a site collection administrator on the site you're reporting on. Without it, the export can't read the groups."
            Color: =RGBA(146, 64, 14, 1)
            Size: =11
            Font: =Font.'Segoe UI'

      # ---------------- Site address field ----------------
      - lblUrlLabel:
          Control: Label
          Properties:
            X: =szCardX + 40
            Y: =322
            Width: =400
            Height: =22
            Text: ="SharePoint site address"
            Color: =clrInk
            Size: =12
            FontWeight: =FontWeight.Semibold
            Font: =Font.'Segoe UI'

      - recUrlField:
          Control: Rectangle
          Properties:
            X: =szCardX + 40
            Y: =350
            Width: =szCard - 80
            Height: =52
            Fill: |
              =If(txtUrl.Focused, clrSurface, RGBA(248, 250, 252, 1))
            BorderColor: |
              =If(
                  varState = "error", clrRed,
                  txtUrl.Focused, clrViolet,
                  clrLine
              )
            BorderThickness: =If(txtUrl.Focused, 2, 1)

      - imgGlobe:
          Control: Image
          Properties:
            X: =szCardX + 58
            Y: =366
            Width: =20
            Height: =20
            Image: |
              ="data:image/svg+xml;utf8, " & EncodeUrl(
                "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none'
                      stroke='" & If(txtUrl.Focused, "#7C3AED", "#64748B") & "'
                      stroke-width='1.8' stroke-linecap='round'>
                   <circle cx='12' cy='12' r='9'/>
                   <path d='M3 12h18'/>
                   <path d='M12 3c2.6 2.7 3.9 5.7 3.9 9s-1.3 6.3-3.9 9c-2.6-2.7-3.9-5.7-3.9-9S9.4 5.7 12 3z'/>
                 </svg>")

      - txtUrl:
          Control: TextInput
          Properties:
            X: =szCardX + 88
            Y: =360
            Width: =szCard - 140
            Height: =32
            Default: =""
            HintText: ="https://contoso.sharepoint.com/sites/SiteName"
            BorderThickness: =0
            Fill: =RGBA(0, 0, 0, 0)
            Color: =clrInk
            Size: =12
            Font: =Font.'Segoe UI'
            OnChange: |
              =Set(varState, "idle"); Set(varError, "")

      # ---------------- Group selector ----------------
      - lblGroupsLabel:
          Control: Label
          Properties:
            X: =szCardX + 40
            Y: =422
            Width: =400
            Height: =22
            Text: ="Groups to include"
            Color: =clrInk
            Size: =12
            FontWeight: =FontWeight.Semibold
            Font: =Font.'Segoe UI'

      - lblGroupsHint:
          Control: Label
          Properties:
            X: =szCardX + szCard - 320
            Y: =424
            Width: =280
            Height: =20
            Text: ="Pick at least one"
            Color: =clrMuted
            Size: =10
            Align: =Align.Right
            Font: =Font.'Segoe UI'

      # --- Owners card ---
      - recOwners:
          Control: Rectangle
          Properties:
            X: =szCardX + 40
            Y: =452
            Width: =256
            Height: =62
            Fill: =If(chkOwners.Value, clrVioletTint, clrSurface)
            BorderColor: =If(chkOwners.Value, clrViolet, clrLine)
            BorderThickness: =If(chkOwners.Value, 2, 1)
            OnSelect: =Select(chkOwners)
            DisplayMode: |
              =If(
                  varState = "success" And varOwnersGroup = "(none configured)",
                  DisplayMode.Disabled,
                  DisplayMode.Edit
              )

      - chkOwners:
          Control: Checkbox
          Properties:
            X: =szCardX + 56
            Y: =470
            Width: =26
            Height: =26
            Default: =true
            Text: =""
            CheckboxBackgroundFill: =clrViolet
            CheckboxBorderColor: =If(Self.Value, clrViolet, clrLine)

      - imgOwners:
          Control: Image
          Properties:
            X: =szCardX + 92
            Y: =470
            Width: =24
            Height: =24
            Image: |
              ="data:image/svg+xml;utf8, " & EncodeUrl(
                "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none'
                      stroke='" & If(chkOwners.Value, "#7C3AED", "#94A3B8") & "'
                      stroke-width='1.7' stroke-linecap='round' stroke-linejoin='round'>
                   <circle cx='9' cy='8' r='3.4'/>
                   <path d='M3.5 19.5c0-3.1 2.5-5.2 5.5-5.2s5.5 2.1 5.5 5.2'/>
                   <path d='M17.2 5.2l1.1 2.3 2.5.35-1.8 1.75.43 2.5-2.24-1.18-2.23 1.18.43-2.5-1.82-1.75 2.52-.35z'/>
                 </svg>")

      - lblOwners:
          Control: Label
          Properties:
            X: =szCardX + 126
            Y: =462
            Width: =160
            Height: =20
            Text: ="Site owners"
            Color: =If(chkOwners.Value, clrVioletDeep, clrInk)
            Size: =12
            FontWeight: =FontWeight.Semibold
            Font: =Font.'Segoe UI'

      - lblOwnersSub:
          Control: Label
          Properties:
            X: =szCardX + 126
            Y: =482
            Width: =160
            Height: =18
            Text: ="Full control"
            Color: =clrMuted
            Size: =10
            Font: =Font.'Segoe UI'

      # --- Members card ---
      - recMembers:
          Control: Rectangle
          Properties:
            X: =szCardX + 312
            Y: =452
            Width: =256
            Height: =62
            Fill: =If(chkMembers.Value, clrVioletTint, clrSurface)
            BorderColor: =If(chkMembers.Value, clrViolet, clrLine)
            BorderThickness: =If(chkMembers.Value, 2, 1)
            OnSelect: =Select(chkMembers)
            DisplayMode: |
              =If(
                  varState = "success" And varMembersGroup = "(none configured)",
                  DisplayMode.Disabled,
                  DisplayMode.Edit
              )

      - chkMembers:
          Control: Checkbox
          Properties:
            X: =szCardX + 328
            Y: =470
            Width: =26
            Height: =26
            Default: =true
            Text: =""
            CheckboxBackgroundFill: =clrViolet
            CheckboxBorderColor: =If(Self.Value, clrViolet, clrLine)

      - imgMembers:
          Control: Image
          Properties:
            X: =szCardX + 364
            Y: =470
            Width: =24
            Height: =24
            Image: |
              ="data:image/svg+xml;utf8, " & EncodeUrl(
                "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none'
                      stroke='" & If(chkMembers.Value, "#7C3AED", "#94A3B8") & "'
                      stroke-width='1.7' stroke-linecap='round' stroke-linejoin='round'>
                   <circle cx='9' cy='8' r='3.4'/>
                   <path d='M2.5 19.5c0-3.1 2.9-5.2 6.5-5.2s6.5 2.1 6.5 5.2'/>
                   <circle cx='17.5' cy='9' r='2.6'/>
                   <path d='M17 14.6c2.4.2 4.5 1.9 4.5 4.9'/>
                 </svg>")

      - lblMembers:
          Control: Label
          Properties:
            X: =szCardX + 398
            Y: =462
            Width: =160
            Height: =20
            Text: ="Site members"
            Color: =If(chkMembers.Value, clrVioletDeep, clrInk)
            Size: =12
            FontWeight: =FontWeight.Semibold
            Font: =Font.'Segoe UI'

      - lblMembersSub:
          Control: Label
          Properties:
            X: =szCardX + 398
            Y: =482
            Width: =160
            Height: =18
            Text: ="Edit"
            Color: =clrMuted
            Size: =10
            Font: =Font.'Segoe UI'

      # --- Visitors card ---
      - recVisitors:
          Control: Rectangle
          Properties:
            X: =szCardX + 584
            Y: =452
            Width: =256
            Height: =62
            Fill: =If(chkVisitors.Value, clrVioletTint, clrSurface)
            BorderColor: =If(chkVisitors.Value, clrViolet, clrLine)
            BorderThickness: =If(chkVisitors.Value, 2, 1)
            OnSelect: =Select(chkVisitors)
            DisplayMode: |
              =If(
                  varState = "success" And varVisitorsGroup = "(none configured)",
                  DisplayMode.Disabled,
                  DisplayMode.Edit
              )

      - chkVisitors:
          Control: Checkbox
          Properties:
            X: =szCardX + 600
            Y: =470
            Width: =26
            Height: =26
            Default: =true
            Text: =""
            CheckboxBackgroundFill: =clrViolet
            CheckboxBorderColor: =If(Self.Value, clrViolet, clrLine)

      - imgVisitors:
          Control: Image
          Properties:
            X: =szCardX + 636
            Y: =470
            Width: =24
            Height: =24
            Image: |
              ="data:image/svg+xml;utf8, " & EncodeUrl(
                "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none'
                      stroke='" & If(chkVisitors.Value, "#7C3AED", "#94A3B8") & "'
                      stroke-width='1.7' stroke-linecap='round' stroke-linejoin='round'>
                   <circle cx='9' cy='8' r='3.4'/>
                   <path d='M3.5 19.5c0-3.1 2.5-5.2 5.5-5.2s5.5 2.1 5.5 5.2'/>
                   <path d='M14.5 12.5c1.6-2.1 3.6-3.1 5.5-3.1'/>
                   <path d='M20 9.4l-.1 2.6M20 9.4l-2.4.3'/>
                 </svg>")

      - lblVisitors:
          Control: Label
          Properties:
            X: =szCardX + 670
            Y: =462
            Width: =160
            Height: =20
            Text: ="Site visitors"
            Color: =If(chkVisitors.Value, clrVioletDeep, clrInk)
            Size: =12
            FontWeight: =FontWeight.Semibold
            Font: =Font.'Segoe UI'

      - lblVisitorsSub:
          Control: Label
          Properties:
            X: =szCardX + 670
            Y: =482
            Width: =160
            Height: =18
            Text: ="Read"
            Color: =clrMuted
            Size: =10
            Font: =Font.'Segoe UI'

      # ---------------- Generate button ----------------
      - btnExport:
          Control: Button
          Properties:
            X: =szCardX + 300
            Y: =544
            Width: =280
            Height: =52
            Text: ="Generate export"
            Fill: =clrViolet
            HoverFill: =clrVioletDeep
            PressedFill: =clrVioletDeep
            DisabledFill: =RGBA(226, 232, 240, 1)
            DisabledColor: =RGBA(148, 163, 184, 1)
            Color: =RGBA(255, 255, 255, 1)
            BorderThickness: =0
            Size: =13
            FontWeight: =FontWeight.Semibold
            Font: =Font.'Segoe UI'
            DisplayMode: |
              =If(
                  IsMatch(
                      TrimEnds(txtUrl.Text),
                      "^https://[\w-]+\.sharepoint\.com(/(sites|teams)/[^/\s]+)?/?$"
                  )
                  And (chkOwners.Value Or chkMembers.Value Or chkVisitors.Value)
                  And varState <> "busy",
                  DisplayMode.Edit,
                  DisplayMode.Disabled
              )
            OnSelect: |
              =Set(varState, "busy");
               Set(varError, "");
               Set(varStep, 1);
               Clear(colAll);
               Set(
                   varGroups,
                   Concat(
                       Filter(
                           Table(
                               { Name: "Owners",   On: chkOwners.Value },
                               { Name: "Members",  On: chkMembers.Value },
                               { Name: "Visitors", On: chkVisitors.Value }
                           ),
                           On
                       ),
                       Name,
                       ","
                   )
               );
               IfError(
                   Set(
                       varRes,
                       GetSiteGroupsApp.Run(TrimEnds(txtUrl.Text), User().Email, varGroups)
                   ),
                   Set(varRes, Blank())
               );
               If(
                   IsBlank(varRes) Or varRes.status <> "Success",
                   Set(
                       varError,
                       If(
                           IsBlank(varRes),
                           "The request didn't finish. Try again in a moment.",
                           varRes.message
                       )
                   );
                   Set(varState, "error"),

                   With(
                       { p: ParseJSON(varRes.payload) },
                       Set(varSiteTitle,     Text(p.siteTitle));
                       Set(varOwnersGroup,   Text(p.ownersGroup));
                       Set(varMembersGroup,  Text(p.membersGroup));
                       Set(varVisitorsGroup, Text(p.visitorsGroup));
                       Set(varFileUrl,       Text(varRes.fileUrl));

                       ForAll(
                           p.owners As o,
                           Collect(
                               colAll,
                               {
                                   Group: "Site Owners",
                                   Title: Text(o.Title),
                                   Email: Text(o.Email),
                                   Role:  Text(p.ownersRole),
                                   MemberType: Switch(
                                       Value(o.PrincipalType),
                                       1, "User",
                                       2, "Distribution List",
                                       4, "Security Group",
                                       8, "SharePoint Group",
                                       "Other"
                                   )
                               }
                           )
                       );
                       ForAll(
                           p.members As m,
                           Collect(
                               colAll,
                               {
                                   Group: "Site Members",
                                   Title: Text(m.Title),
                                   Email: Text(m.Email),
                                   Role:  Text(p.membersRole),
                                   MemberType: Switch(
                                       Value(m.PrincipalType),
                                       1, "User",
                                       2, "Distribution List",
                                       4, "Security Group",
                                       8, "SharePoint Group",
                                       "Other"
                                   )
                               }
                           )
                       );
                       ForAll(
                           p.visitors As v,
                           Collect(
                               colAll,
                               {
                                   Group: "Site Visitors",
                                   Title: Text(v.Title),
                                   Email: Text(v.Email),
                                   Role:  Text(p.visitorsRole),
                                   MemberType: Switch(
                                       Value(v.PrincipalType),
                                       1, "User",
                                       2, "Distribution List",
                                       4, "Security Group",
                                       8, "SharePoint Group",
                                       "Other"
                                   )
                               }
                           )
                       )
                   );
                   If(
                       CountRows(colAll) = 0,
                       Set(varError, "Those groups exist but have no users in them.");
                       Set(varState, "error"),
                       Set(varState, "success")
                   )
               )

      - imgDownload:
          Control: Image
          Properties:
            X: =szCardX + 344
            Y: =558
            Width: =22
            Height: =22
            DisplayMode: =DisplayMode.Disabled
            Visible: =btnExport.DisplayMode = DisplayMode.Edit
            Image: |
              ="data:image/svg+xml;utf8, " & EncodeUrl(
                "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none'
                      stroke='#FFFFFF' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'>
                   <path d='M12 3v11'/><path d='M7.5 10l4.5 4.5 4.5-4.5'/>
                   <path d='M4 18.5v1.2a1.3 1.3 0 0 0 1.3 1.3h13.4a1.3 1.3 0 0 0 1.3-1.3v-1.2'/>
                 </svg>")

      # ---------------- Status strip ----------------
      - recStatus:
          Control: Rectangle
          Properties:
            X: =szCardX + 40
            Y: =612
            Width: =szCard - 80
            Height: =If(varState = "error", 56, 34)
            Visible: =varState <> "busy"
            Fill: |
              =Switch(
                  varState,
                  "error",   clrRedTint,
                  "success", RGBA(236, 253, 245, 1),
                  RGBA(0, 0, 0, 0)
              )
            BorderColor: |
              =Switch(
                  varState,
                  "error",   RGBA(220, 38, 38, 0.25),
                  "success", RGBA(16, 185, 129, 0.25),
                  RGBA(0, 0, 0, 0)
              )
            BorderThickness: =If(varState = "idle", 0, 1)

      - imgStatus:
          Control: Image
          Properties:
            X: =szCardX + 58
            Y: =620
            Width: =18
            Height: =18
            Visible: =varState <> "busy"
            Image: |
              ="data:image/svg+xml;utf8, " & EncodeUrl(
                Switch(
                    varState,
                    "error",
                      "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none'
                            stroke='#DC2626' stroke-width='2' stroke-linecap='round'>
                         <path d='M10.3 3.9 1.9 18.4A2 2 0 0 0 3.6 21.4h16.8a2 2 0 0 0 1.7-3L13.7 3.9a2 2 0 0 0-3.4 0z'/>
                         <path d='M12 9.5v4'/><circle cx='12' cy='17' r='.9' fill='#DC2626' stroke='none'/>
                       </svg>",
                    "success",
                      "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none'
                            stroke='#10B981' stroke-width='2.2' stroke-linecap='round' stroke-linejoin='round'>
                         <circle cx='12' cy='12' r='9'/><path d='M8 12.4l2.7 2.7L16 9.8'/>
                       </svg>",
                    "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none'
                          stroke='#64748B' stroke-width='1.8' stroke-linecap='round'>
                       <circle cx='12' cy='12' r='9'/><path d='M12 11v5.5'/>
                       <circle cx='12' cy='7.8' r='.9' fill='#64748B' stroke='none'/>
                     </svg>"
                ))

      - lblStatus:
          Control: Label
          Properties:
            X: =szCardX + 86
            Y: =614
            Width: =szCard - 190
            Height: =If(varState = "error", 52, 30)
            Visible: =varState <> "busy"
            AutoHeight: =true
            Text: |
              =Switch(
                  varState,
                  "error",   varError,
                  "success", "Exported " & CountRows(colAll) & " users from " & varSiteTitle & ".",
                  "The export includes each user's name, email, group and permission level."
              )
            Color: |
              =Switch(
                  varState,
                  "error",   RGBA(153, 27, 27, 1),
                  "success", RGBA(6, 95, 70, 1),
                  clrMuted
              )
            Size: =11
            Font: =Font.'Segoe UI'

      - lblOpenFile:
          Control: Label
          Properties:
            X: =szCardX + szCard - 148
            Y: =614
            Width: =108
            Height: =30
            Visible: =varState = "success" And Not IsBlank(varFileUrl)
            Text: ="Open file"
            Color: =clrViolet
            Size: =11
            FontWeight: =FontWeight.Semibold
            Underline: =true
            Align: =Align.Right
            Font: =Font.'Segoe UI'
            OnSelect: =Launch(varFileUrl)

      # =============================================================
      #  LOADING OVERLAY
      # =============================================================
      - tmrSpin:
          Control: Timer
          Properties:
            X: =-100
            Y: =-100
            Width: =1
            Height: =1
            Duration: =900
            Repeat: =true
            AutoStart: =false
            Start: =varState = "busy"
            Visible: =false
            OnTimerEnd: |
              =Set(varStep, If(varStep >= 4, 4, varStep + 1))

      - recScrim:
          Control: Rectangle
          Properties:
            X: =0
            Y: =0
            Width: =Parent.Width
            Height: =Parent.Height
            Visible: =varState = "busy"
            Fill: =RGBA(15, 23, 42, 0.55)

      - recLoadCard:
          Control: Rectangle
          Properties:
            X: =(Parent.Width - 420) / 2
            Y: =(Parent.Height - 260) / 2
            Width: =420
            Height: =260
            Visible: =varState = "busy"
            Fill: =clrSurface

      - recLoadAccent:
          Control: Rectangle
          Properties:
            X: =(Parent.Width - 420) / 2
            Y: =(Parent.Height - 260) / 2
            Width: =420
            Height: =4
            Visible: =varState = "busy"
            Fill: =clrViolet

      # Rotating ring — angle is driven off the timer tick
      - imgSpinner:
          Control: Image
          Properties:
            X: =(Parent.Width - 72) / 2
            Y: =(Parent.Height - 260) / 2 + 44
            Width: =72
            Height: =72
            Visible: =varState = "busy"
            Image: |
              ="data:image/svg+xml;utf8, " & EncodeUrl(
                "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 72 72' fill='none'>
                   <circle cx='36' cy='36' r='28' stroke='#EDE9FE' stroke-width='7'/>
                   <g transform='rotate(" &
                        Text(RoundDown(tmrSpin.Value / 900 * 360, 0)) &
                        " 36 36)'>
                     <path d='M36 8 A28 28 0 0 1 64 36' stroke='#7C3AED'
                           stroke-width='7' stroke-linecap='round'/>
                   </g>
                   <circle cx='36' cy='36' r='13' fill='#F5F3FF'/>
                   <path d='M36 30v9' stroke='#7C3AED' stroke-width='2.4' stroke-linecap='round'/>
                   <path d='M32.4 36.2 36 39.8l3.6-3.6' stroke='#7C3AED'
                         stroke-width='2.4' stroke-linecap='round' stroke-linejoin='round'/>
                 </svg>")

      - lblLoadMsg:
          Control: Label
          Properties:
            X: =(Parent.Width - 380) / 2
            Y: =(Parent.Height - 260) / 2 + 132
            Width: =380
            Height: =26
            Visible: =varState = "busy"
            Text: =LookUp(tblSteps, Idx = varStep).Msg
            Color: =clrInk
            Size: =14
            FontWeight: =FontWeight.Semibold
            Align: =Align.Center
            Font: =Font.'Segoe UI'

      - lblLoadSub:
          Control: Label
          Properties:
            X: =(Parent.Width - 380) / 2
            Y: =(Parent.Height - 260) / 2 + 158
            Width: =380
            Height: =22
            Visible: =varState = "busy"
            Text: =LookUp(tblSteps, Idx = varStep).Sub
            Color: =clrMuted
            Size: =11
            Align: =Align.Center
            Font: =Font.'Segoe UI'

      # Four step pips — fill as varStep advances
      - galSteps:
          Control: Gallery
          Variant: Horizontal
          Properties:
            X: =(Parent.Width - 128) / 2
            Y: =(Parent.Height - 260) / 2 + 196
            Width: =128
            Height: =12
            Visible: =varState = "busy"
            ShowScrollbar: =false
            TemplateSize: =32
            TemplatePadding: =0
            Items: =tblSteps
          Children:
            - recPip:
                Control: Rectangle
                Properties:
                  X: =0
                  Y: =3
                  Width: =24
                  Height: =6
                  Fill: |
                    =If(ThisItem.Idx <= varStep, clrViolet, RGBA(226, 232, 240, 1))
