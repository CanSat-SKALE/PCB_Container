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

Procedure CreateComponentSOT230P700X180_4L25N(Zero : integer);
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
        NewPcbLibComp.Name := 'SOT230P700X180-4L25N';
        NewPCBLibComp.Description := 'Small Outline Transistor (SOT223), 2.30 mm pitch; 4 pin, 6.50 mm L X 3.50 mm W X 1.80 mm H body';
        NewPCBLibComp.Height := MMsToCoord(1.8);

        CreateSMDComponentPad(NewPCBLibComp, '1', eTopLayer, -2.3, -3.05, 0, 0, eRoundedRectangular, 1.91, 0.92, 270, 50, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '2', eTopLayer, 0, -3.05, 0, 0, eRoundedRectangular, 1.91, 0.92, 270, 50, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '3', eTopLayer, 2.3, -3.05, 0, 0, eRoundedRectangular, 1.91, 0.92, 270, 50, 0, 0, True, True);
        CreateSMDComponentPad(NewPCBLibComp, '4', eTopLayer, 0, 3.05, 0, 0, eRoundedRectangular, 1.91, 3.19, 90, 24.08, 0, 0, True, True);

        CreateComponentArc(NewPCBLibComp, 0, 0, 0.25, 0, 360, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, 0, 0.35, 0, -0.35, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, -0.35, 0, 0.35, 0, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, -3.35, -1.85, -3.35, 1.85, eMechanical11, 0.12, False);
        CreateComponentTrack(NewPCBLibComp, -3.35, 1.85, 3.35, 1.85, eMechanical11, 0.12, False);
        CreateComponentTrack(NewPCBLibComp, 3.35, 1.85, 3.35, -1.85, eMechanical11, 0.12, False);
        CreateComponentTrack(NewPCBLibComp, 3.35, -1.85, -3.35, -1.85, eMechanical11, 0.12, False);
        CreateComponentTrack(NewPCBLibComp, -3.6, -2.1, -3.01, -2.1, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, -3.01, -2.1, -3.01, -4.26, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, -3.01, -4.26, 3.01, -4.26, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, 3.01, -4.26, 3.01, -2.1, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, 3.01, -2.1, 3.6, -2.1, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, 3.6, -2.1, 3.6, 2.1, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, 3.6, 2.1, 1.85, 2.1, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, 1.85, 2.1, 1.85, 4.26, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, 1.85, 4.26, -1.85, 4.26, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, -1.85, 4.26, -1.85, 2.1, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, -1.85, 2.1, -3.6, 2.1, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, -3.6, 2.1, -3.6, -2.1, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, 2.94, -1.85, 3.35, -1.85, eTopOverlay, 0.12, False);
        CreateComponentTrack(NewPCBLibComp, 3.35, -1.85, 3.35, 1.85, eTopOverlay, 0.12, False);
        CreateComponentTrack(NewPCBLibComp, 3.35, 1.85, 1.775, 1.85, eTopOverlay, 0.12, False);
        CreateComponentTrack(NewPCBLibComp, -2.94, -1.85, -3.35, -1.85, eTopOverlay, 0.12, False);
        CreateComponentTrack(NewPCBLibComp, -3.35, -1.85, -3.35, 1.85, eTopOverlay, 0.12, False);
        CreateComponentTrack(NewPCBLibComp, -3.35, 1.85, -1.775, 1.85, eTopOverlay, 0.12, False);

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

    CreateComponentSOT230P700X180_4L25N(0);

End;

End.
