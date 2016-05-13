Var
    CurrentLib : IPCB_Library;

Procedure CreateSMDComponentPad(NewPCBLibComp : IPCB_LibComponent, Name : String, Layer : TLayer, X : Real, Y : Real, OffsetX : Real, OffsetY : Real,
                                TopShape : TShape, TopXSize : Real, TopYSize : Real, Rotation: Real, CRRatio : Real, PMExpansion : Real, SMExpansion : Real,
                                PMFromRules : Boolean, SMFromRules : Boolean);
Var
    NewPad                      : IPCB_Pad2;
    PadCache                    : TPadCache;

Begin
    NewPad := PcbServer.PCBObjectFactory(ePadObject, eNoDimension, eCreate_Default);
    NewPad.HoleSize := MMsToCoord(0);
    NewPad.Layer    := Layer;
    NewPad.TopShape := TopShape;
    if TopShape = eRoundedRectangular then
        NewPad.SetState_StackCRPctOnLayer(eTopLayer, CRRatio);
    NewPad.TopXSize := MMsToCoord(TopXSize);
    NewPad.TopYSize := MMsToCoord(TopYSize);
    NewPad.RotateBy(Rotation);
    NewPad.MoveToXY(MMsToCoord(X), MMsToCoord(Y));
    NewPad.Name := Name;

    Padcache := NewPad.GetState_Cache;
    if (PMExpansion <> 0) or (PMFromRules = False) then
    Begin
        Padcache.PasteMaskExpansionValid   := eCacheManual;
        Padcache.PasteMaskExpansion        := MMsToCoord(PMExpansion);
    End;
    if (SMExpansion <> 0) or (SMFromRules = False) then
    Begin
        Padcache.SolderMaskExpansionValid  := eCacheManual;
        Padcache.SolderMaskExpansion       := MMsToCoord(SMExpansion);
    End;
    NewPad.SetState_Cache              := Padcache;

    NewPCBLibComp.AddPCBObject(NewPad);
    PCBServer.SendMessageToRobots(NewPCBLibComp.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,NewPad.I_ObjectAddress);
End;

Procedure CreateComponentTrack(NewPCBLibComp : IPCB_LibComponent, X1 : Real, Y1 : Real, X2 : Real, Y2 : Real, Layer : TLayer, LineWidth : Real, IsKeepout : Boolean);
Var
    NewTrack                    : IPCB_Track;

Begin
    NewTrack := PcbServer.PCBObjectFactory(eTrackObject,eNoDimension,eCreate_Default);
    NewTrack.X1 := MMsToCoord(X1);
    NewTrack.Y1 := MMsToCoord(Y1);
    NewTrack.X2 := MMsToCoord(X2);
    NewTrack.Y2 := MMsToCoord(Y2);
    NewTrack.Layer := Layer;
    NewTrack.Width := MMsToCoord(LineWidth);
    NewTrack.IsKeepout := IsKeepout;
    NewPCBLibComp.AddPCBObject(NewTrack);
    PCBServer.SendMessageToRobots(NewPCBLibComp.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,NewTrack.I_ObjectAddress);
End;

Procedure CreateComponentArc(NewPCBLibComp : IPCB_LibComponent, CenterX : Real, CenterY: Real, Radius : Real, StartAngle : Real, EndAngle : Real, Layer : TLayer, LineWidth : Real, IsKeepout : Boolean);
Var
    NewArc                      : IPCB_Arc;

Begin
    NewArc := PCBServer.PCBObjectFactory(eArcObject,eNoDimension,eCreate_Default);
    NewArc.XCenter := MMsToCoord(CenterX);
    NewArc.YCenter := MMsToCoord(CenterY);
    NewArc.Radius := MMsToCoord(Radius);
    NewArc.StartAngle := StartAngle;
    NewArc.EndAngle := EndAngle;
    NewArc.Layer := Layer;
    NewArc.LineWidth := MMsToCoord(LineWidth);
    NewArc.IsKeepout := IsKeepout;
    NewPCBLibComp.AddPCBObject(NewArc);
    PCBServer.SendMessageToRobots(NewPCBLibComp.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,NewArc.I_ObjectAddress);
End;

Procedure CreateComponentSON45P200X300X75_9T165X135M(Zero : integer);
Var
    NewPCBLibComp               : IPCB_LibComponent;
    NewPad                      : IPCB_Pad2;
    NewRegion                   : IPCB_Region;
    NewContour                  : IPCB_Contour;
    STEPmodel                   : IPCB_ComponentBody;
    Model                       : IPCB_Model;

Begin
    Try
        PCBServer.PreProcess;

        NewPCBLibComp := PCBServer.CreatePCBLibComp;
        NewPcbLibComp.Name := 'SON45P200X300X75-9T165X135M';
        NewPCBLibComp.Description := 'Small Outline No-Lead (SON with Tab), 0.45 mm pitch; 8 pin, 2.00 mm L X 3.00 mm W X 0.75 mm H body';
        NewPCBLibComp.Height := MMsToCoord(0.75);

        CreateSMDComponentPad(NewPCBLibComp, '1', eTopLayer, -0.675, -1.495, 0, 0, eRoundedRectangular, 0.94, 0.25, 270, 48, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '2', eTopLayer, -0.225, -1.495, 0, 0, eRoundedRectangular, 0.94, 0.25, 270, 48, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '3', eTopLayer, 0.225, -1.495, 0, 0, eRoundedRectangular, 0.94, 0.25, 270, 48, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '4', eTopLayer, 0.675, -1.495, 0, 0, eRoundedRectangular, 0.94, 0.25, 270, 48, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '5', eTopLayer, 0.675, 1.495, 0, 0, eRoundedRectangular, 0.94, 0.25, 90, 48, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '6', eTopLayer, 0.225, 1.495, 0, 0, eRoundedRectangular, 0.94, 0.25, 90, 48, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '7', eTopLayer, -0.225, 1.495, 0, 0, eRoundedRectangular, 0.94, 0.25, 90, 48, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '8', eTopLayer, -0.675, 1.495, 0, 0, eRoundedRectangular, 0.94, 0.25, 90, 48, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '9', eTopLayer, 0, 0, 0, 0, eRectangular, 1.25, 1.35, 90, 0, -1.35, 0, True, False);

        NewRegion := PCBServer.PCBObjectFactory(eRegionObject, eNoDimension, eCreate_Default);
        NewContour := PCBServer.PCBContourFactory;
        NewContour.AddPoint(MMsToCoord(0.675), MMsToCoord(0));
        NewContour.AddPoint(MMsToCoord(0.675), MMsToCoord(-0.775));
        NewContour.AddPoint(MMsToCoord(0.6744), MMsToCoord(-0.7828));
        NewContour.AddPoint(MMsToCoord(0.6726), MMsToCoord(-0.7905));
        NewContour.AddPoint(MMsToCoord(0.6696), MMsToCoord(-0.7977));
        NewContour.AddPoint(MMsToCoord(0.6655), MMsToCoord(-0.8044));
        NewContour.AddPoint(MMsToCoord(0.6604), MMsToCoord(-0.8104));
        NewContour.AddPoint(MMsToCoord(0.6544), MMsToCoord(-0.8155));
        NewContour.AddPoint(MMsToCoord(0.6477), MMsToCoord(-0.8196));
        NewContour.AddPoint(MMsToCoord(0.6405), MMsToCoord(-0.8226));
        NewContour.AddPoint(MMsToCoord(0.6328), MMsToCoord(-0.8244));
        NewContour.AddPoint(MMsToCoord(-0.475), MMsToCoord(-0.825));
        NewContour.AddPoint(MMsToCoord(-0.675), MMsToCoord(-0.625));
        NewContour.AddPoint(MMsToCoord(-0.675), MMsToCoord(0.775));
        NewContour.AddPoint(MMsToCoord(-0.6744), MMsToCoord(0.7828));
        NewContour.AddPoint(MMsToCoord(-0.6726), MMsToCoord(0.7905));
        NewContour.AddPoint(MMsToCoord(-0.6696), MMsToCoord(0.7977));
        NewContour.AddPoint(MMsToCoord(-0.6655), MMsToCoord(0.8044));
        NewContour.AddPoint(MMsToCoord(-0.6604), MMsToCoord(0.8104));
        NewContour.AddPoint(MMsToCoord(-0.6544), MMsToCoord(0.8155));
        NewContour.AddPoint(MMsToCoord(-0.6477), MMsToCoord(0.8196));
        NewContour.AddPoint(MMsToCoord(-0.6405), MMsToCoord(0.8226));
        NewContour.AddPoint(MMsToCoord(-0.6328), MMsToCoord(0.8244));
        NewContour.AddPoint(MMsToCoord(0.625), MMsToCoord(0.825));
        NewContour.AddPoint(MMsToCoord(0.6328), MMsToCoord(0.8244));
        NewContour.AddPoint(MMsToCoord(0.6405), MMsToCoord(0.8226));
        NewContour.AddPoint(MMsToCoord(0.6477), MMsToCoord(0.8196));
        NewContour.AddPoint(MMsToCoord(0.6544), MMsToCoord(0.8155));
        NewContour.AddPoint(MMsToCoord(0.6604), MMsToCoord(0.8104));
        NewContour.AddPoint(MMsToCoord(0.6655), MMsToCoord(0.8044));
        NewContour.AddPoint(MMsToCoord(0.6696), MMsToCoord(0.7977));
        NewContour.AddPoint(MMsToCoord(0.6726), MMsToCoord(0.7905));
        NewContour.AddPoint(MMsToCoord(0.6744), MMsToCoord(0.7828));
        NewContour.AddPoint(MMsToCoord(0.675), MMsToCoord(0.775));
        NewContour.AddPoint(MMsToCoord(0.675), MMsToCoord(0));
        NewRegion.SetOutlineContour(NewContour);
        NewRegion.Layer := eTopLayer;
        NewPCBLibComp.AddPCBObject(NewRegion);

        NewRegion := PCBServer.PCBObjectFactory(eRegionObject, eNoDimension, eCreate_Default);
        NewContour := PCBServer.PCBContourFactory;
        NewContour.AddPoint(MMsToCoord(0.675), MMsToCoord(0));
        NewContour.AddPoint(MMsToCoord(0.675), MMsToCoord(-0.775));
        NewContour.AddPoint(MMsToCoord(0.6744), MMsToCoord(-0.7828));
        NewContour.AddPoint(MMsToCoord(0.6726), MMsToCoord(-0.7905));
        NewContour.AddPoint(MMsToCoord(0.6696), MMsToCoord(-0.7977));
        NewContour.AddPoint(MMsToCoord(0.6655), MMsToCoord(-0.8044));
        NewContour.AddPoint(MMsToCoord(0.6604), MMsToCoord(-0.8104));
        NewContour.AddPoint(MMsToCoord(0.6544), MMsToCoord(-0.8155));
        NewContour.AddPoint(MMsToCoord(0.6477), MMsToCoord(-0.8196));
        NewContour.AddPoint(MMsToCoord(0.6405), MMsToCoord(-0.8226));
        NewContour.AddPoint(MMsToCoord(0.6328), MMsToCoord(-0.8244));
        NewContour.AddPoint(MMsToCoord(-0.475), MMsToCoord(-0.825));
        NewContour.AddPoint(MMsToCoord(-0.675), MMsToCoord(-0.625));
        NewContour.AddPoint(MMsToCoord(-0.675), MMsToCoord(0.775));
        NewContour.AddPoint(MMsToCoord(-0.6744), MMsToCoord(0.7828));
        NewContour.AddPoint(MMsToCoord(-0.6726), MMsToCoord(0.7905));
        NewContour.AddPoint(MMsToCoord(-0.6696), MMsToCoord(0.7977));
        NewContour.AddPoint(MMsToCoord(-0.6655), MMsToCoord(0.8044));
        NewContour.AddPoint(MMsToCoord(-0.6604), MMsToCoord(0.8104));
        NewContour.AddPoint(MMsToCoord(-0.6544), MMsToCoord(0.8155));
        NewContour.AddPoint(MMsToCoord(-0.6477), MMsToCoord(0.8196));
        NewContour.AddPoint(MMsToCoord(-0.6405), MMsToCoord(0.8226));
        NewContour.AddPoint(MMsToCoord(-0.6328), MMsToCoord(0.8244));
        NewContour.AddPoint(MMsToCoord(0.625), MMsToCoord(0.825));
        NewContour.AddPoint(MMsToCoord(0.6328), MMsToCoord(0.8244));
        NewContour.AddPoint(MMsToCoord(0.6405), MMsToCoord(0.8226));
        NewContour.AddPoint(MMsToCoord(0.6477), MMsToCoord(0.8196));
        NewContour.AddPoint(MMsToCoord(0.6544), MMsToCoord(0.8155));
        NewContour.AddPoint(MMsToCoord(0.6604), MMsToCoord(0.8104));
        NewContour.AddPoint(MMsToCoord(0.6655), MMsToCoord(0.8044));
        NewContour.AddPoint(MMsToCoord(0.6696), MMsToCoord(0.7977));
        NewContour.AddPoint(MMsToCoord(0.6726), MMsToCoord(0.7905));
        NewContour.AddPoint(MMsToCoord(0.6744), MMsToCoord(0.7828));
        NewContour.AddPoint(MMsToCoord(0.675), MMsToCoord(0.775));
        NewContour.AddPoint(MMsToCoord(0.675), MMsToCoord(0));
        NewRegion.SetOutlineContour(NewContour);
        NewRegion.Layer := eTopSolder;
        NewPCBLibComp.AddPCBObject(NewRegion);


        NewRegion := PCBServer.PCBObjectFactory(eRegionObject, eNoDimension, eCreate_Default);
        NewContour := PCBServer.PCBContourFactory;
        NewContour.AddPoint(MMsToCoord(0.46), MMsToCoord(-0.68));
        NewContour.AddPoint(MMsToCoord(-0.46), MMsToCoord(-0.68));
        NewContour.AddPoint(MMsToCoord(-0.46), MMsToCoord(-0.07));
        NewContour.AddPoint(MMsToCoord(0.46), MMsToCoord(-0.07));
        NewContour.AddPoint(MMsToCoord(0.46), MMsToCoord(-0.68));
        NewRegion.SetOutlineContour(NewContour);
        NewRegion.Layer := eTopPaste;
        NewPCBLibComp.AddPCBObject(NewRegion);

        NewRegion := PCBServer.PCBObjectFactory(eRegionObject, eNoDimension, eCreate_Default);
        NewContour := PCBServer.PCBContourFactory;
        NewContour.AddPoint(MMsToCoord(0.46), MMsToCoord(0.07));
        NewContour.AddPoint(MMsToCoord(-0.46), MMsToCoord(0.07));
        NewContour.AddPoint(MMsToCoord(-0.46), MMsToCoord(0.68));
        NewContour.AddPoint(MMsToCoord(0.46), MMsToCoord(0.68));
        NewContour.AddPoint(MMsToCoord(0.46), MMsToCoord(0.07));
        NewRegion.SetOutlineContour(NewContour);
        NewRegion.Layer := eTopPaste;
        NewPCBLibComp.AddPCBObject(NewRegion);

        CreateComponentArc(NewPCBLibComp, 0, 0, 0.25, 0, 360, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, 0, 0.35, 0, -0.35, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, -0.35, 0, 0.35, 0, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, -1.05, -1.55, -1.05, 1.55, eMechanical11, 0.12, False);
        CreateComponentTrack(NewPCBLibComp, -1.05, 1.55, 1.05, 1.55, eMechanical11, 0.12, False);
        CreateComponentTrack(NewPCBLibComp, 1.05, 1.55, 1.05, -1.55, eMechanical11, 0.12, False);
        CreateComponentTrack(NewPCBLibComp, 1.05, -1.55, -1.05, -1.55, eMechanical11, 0.12, False);
        CreateComponentTrack(NewPCBLibComp, -1.55, -2.05, -1.3, -2.05, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, -1.3, -2.05, -1.3, -2.47, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, -1.3, -2.47, 1.3, -2.47, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, 1.3, -2.47, 1.3, -2.05, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, 1.3, -2.05, 1.55, -2.05, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, 1.55, -2.05, 1.55, 2.05, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, 1.55, 2.05, 1.3, 2.05, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, 1.3, 2.05, 1.3, 2.47, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, 1.3, 2.47, -1.3, 2.47, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, -1.3, 2.47, -1.3, 2.05, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, -1.3, 2.05, -1.55, 2.05, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, -1.55, 2.05, -1.55, -2.05, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, -1.05, -1.55, -1.05, 1.55, eTopOverlay, 0.15, False);
        CreateComponentTrack(NewPCBLibComp, 1.05, -1.55, 1.05, 1.55, eTopOverlay, 0.15, False);

        CurrentLib.RegisterComponent(NewPCBLibComp);
        CurrentLib.CurrentComponent := NewPcbLibComp;
    Finally
        PCBServer.PostProcess;
    End;

    CurrentLib.Board.ViewManager_FullUpdate;
    Client.SendMessage('PCB:Zoom', 'Action=All' , 255, Client.CurrentView)
End;

Procedure CreateALibrary;
Var
    View     : IServerDocumentView;
    Document : IServerDocument;

Begin
    If PCBServer = Nil Then
    Begin
        ShowMessage('No PCBServer present. This script inserts a footprint into an existing PCB Library that has the current focus.');
        Exit;
    End;

    CurrentLib := PcbServer.GetCurrentPCBLibrary;
    If CurrentLib = Nil Then
    Begin
        ShowMessage('You must have focus on a PCB Library in order for this script to run.');
        Exit;
    End;

    View := Client.GetCurrentView;
    Document := View.OwnerDocument;
    Document.Modified := True;

    CreateComponentSON45P200X300X75_9T165X135M(0);

End;

End.
