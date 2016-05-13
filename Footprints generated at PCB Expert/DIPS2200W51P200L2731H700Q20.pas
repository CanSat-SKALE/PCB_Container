Var
    CurrentLib : IPCB_Library;

Procedure CreateTHComponentPad(NewPCBLibComp : IPCB_LibComponent, Name : String, HoleType : TExtendedHoleType,
                               HoleSize : Real, HoleLength : Real, Layer : TLayer, X : Real, Y : Real,
                               OffsetX : Real, OffsetY : Real, TopShape : TShape, TopXSize : Real, TopYSize : Real,
                               InnerShape : TShape, InnerXSize : Real, InnerYSize : Real,
                               BottomShape : TShape, BottomXSize : Real, BottomYSize : Real,
                               Rotation: Real, CRRatio : Real, PMExpansion : Real, SMExpansion: Real, Plated : Boolean);
Var
    NewPad                      : IPCB_Pad2;
    PadCache                    : TPadCache;

Begin
    NewPad := PcbServer.PCBObjectFactory(ePadObject, eNoDimension, eCreate_Default);
    NewPad.HoleType := HoleType;
    NewPad.HoleSize := MMsToCoord(HoleSize);
    if HoleLength <> 0 then
        NewPad.HoleWidth := MMsToCoord(HoleLength);
    NewPad.TopShape := TopShape;
    if TopShape = eRoundedRectangular then
        NewPad.SetState_StackCRPctOnLayer(eTopLayer, CRRatio);
    NewPad.TopXSize := MMsToCoord(TopXSize);
    NewPad.TopYSize := MMsToCoord(TopYSize);
    NewPad.MidShape := InnerShape;
    NewPad.MidXSize := MMsToCoord(InnerXSize);
    NewPad.MidYSize := MMsToCoord(InnerYSize);
    NewPad.BotShape := BottomShape;
    NewPad.BotXSize := MMsToCoord(BottomXSize);
    NewPad.BotYSize := MMsToCoord(BottomYSize);
    NewPad.SetState_XPadOffsetOnLayer(Layer, MMsToCoord(OffsetX));
    NewPad.SetState_YPadOffsetOnLayer(Layer, MMsToCoord(OffsetY));
    NewPad.RotateBy(Rotation);
    NewPad.MoveToXY(MMsToCoord(X), MMsToCoord(Y));
    NewPad.Plated   := Plated;
    NewPad.Name := Name;

    Padcache := NewPad.GetState_Cache;
    if PMExpansion <> 0 then
    Begin
        Padcache.PasteMaskExpansionValid   := eCacheManual;
        Padcache.PasteMaskExpansion        := MMsToCoord(PMExpansion);
    End;
    if SMExpansion <> 0 then
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

Procedure CreateComponentDIPS2200W51P200L2731H700Q20(Zero : integer);
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
        NewPcbLibComp.Name := 'DIPS2200W51P200L2731H700Q20';
        NewPCBLibComp.Description := 'DIPS, 22.00 mm lead span, 2.00 mm pitch; 20 pin, 27.31 mm L X 22.38 mm W X 7.00 mm H body';
        NewPCBLibComp.Height := MMsToCoord(7);

        CreateTHComponentPad(NewPCBLibComp, '1', eRoundHole, 0.95, 0, eBottomLayer, -9, -11, 0, 0, eRectangular, 1.43, 1.43, eRounded, 1.43, 1.43, eRectangular, 1.43, 1.43, 90, 0, -1.43, 0, True);
        CreateTHComponentPad(NewPCBLibComp, '2', eRoundHole, 0.95, 0, eBottomLayer, -7, -11, 0, 0, eRounded, 1.43, 1.43, eRounded, 1.43, 1.43, eRounded, 1.43, 1.43, 0, 0, -1.43, 0, True);
        CreateTHComponentPad(NewPCBLibComp, '3', eRoundHole, 0.95, 0, eBottomLayer, -5, -11, 0, 0, eRounded, 1.43, 1.43, eRounded, 1.43, 1.43, eRounded, 1.43, 1.43, 0, 0, -1.43, 0, True);
        CreateTHComponentPad(NewPCBLibComp, '4', eRoundHole, 0.95, 0, eBottomLayer, -3, -11, 0, 0, eRounded, 1.43, 1.43, eRounded, 1.43, 1.43, eRounded, 1.43, 1.43, 0, 0, -1.43, 0, True);
        CreateTHComponentPad(NewPCBLibComp, '5', eRoundHole, 0.95, 0, eBottomLayer, -1, -11, 0, 0, eRounded, 1.43, 1.43, eRounded, 1.43, 1.43, eRounded, 1.43, 1.43, 0, 0, -1.43, 0, True);
        CreateTHComponentPad(NewPCBLibComp, '6', eRoundHole, 0.95, 0, eBottomLayer, 1, -11, 0, 0, eRounded, 1.43, 1.43, eRounded, 1.43, 1.43, eRounded, 1.43, 1.43, 0, 0, -1.43, 0, True);
        CreateTHComponentPad(NewPCBLibComp, '7', eRoundHole, 0.95, 0, eBottomLayer, 3, -11, 0, 0, eRounded, 1.43, 1.43, eRounded, 1.43, 1.43, eRounded, 1.43, 1.43, 0, 0, -1.43, 0, True);
        CreateTHComponentPad(NewPCBLibComp, '8', eRoundHole, 0.95, 0, eBottomLayer, 5, -11, 0, 0, eRounded, 1.43, 1.43, eRounded, 1.43, 1.43, eRounded, 1.43, 1.43, 0, 0, -1.43, 0, True);
        CreateTHComponentPad(NewPCBLibComp, '9', eRoundHole, 0.95, 0, eBottomLayer, 7, -11, 0, 0, eRounded, 1.43, 1.43, eRounded, 1.43, 1.43, eRounded, 1.43, 1.43, 0, 0, -1.43, 0, True);
        CreateTHComponentPad(NewPCBLibComp, '10', eRoundHole, 0.95, 0, eBottomLayer, 9, -11, 0, 0, eRounded, 1.43, 1.43, eRounded, 1.43, 1.43, eRounded, 1.43, 1.43, 0, 0, -1.43, 0, True);
        CreateTHComponentPad(NewPCBLibComp, '11', eRoundHole, 0.95, 0, eBottomLayer, 9, 11, 0, 0, eRounded, 1.43, 1.43, eRounded, 1.43, 1.43, eRounded, 1.43, 1.43, 0, 0, -1.43, 0, True);
        CreateTHComponentPad(NewPCBLibComp, '12', eRoundHole, 0.95, 0, eBottomLayer, 7, 11, 0, 0, eRounded, 1.43, 1.43, eRounded, 1.43, 1.43, eRounded, 1.43, 1.43, 0, 0, -1.43, 0, True);
        CreateTHComponentPad(NewPCBLibComp, '13', eRoundHole, 0.95, 0, eBottomLayer, 5, 11, 0, 0, eRounded, 1.43, 1.43, eRounded, 1.43, 1.43, eRounded, 1.43, 1.43, 0, 0, -1.43, 0, True);
        CreateTHComponentPad(NewPCBLibComp, '14', eRoundHole, 0.95, 0, eBottomLayer, 3, 11, 0, 0, eRounded, 1.43, 1.43, eRounded, 1.43, 1.43, eRounded, 1.43, 1.43, 0, 0, -1.43, 0, True);
        CreateTHComponentPad(NewPCBLibComp, '15', eRoundHole, 0.95, 0, eBottomLayer, 1, 11, 0, 0, eRounded, 1.43, 1.43, eRounded, 1.43, 1.43, eRounded, 1.43, 1.43, 0, 0, -1.43, 0, True);
        CreateTHComponentPad(NewPCBLibComp, '16', eRoundHole, 0.95, 0, eBottomLayer, -1, 11, 0, 0, eRounded, 1.43, 1.43, eRounded, 1.43, 1.43, eRounded, 1.43, 1.43, 0, 0, -1.43, 0, True);
        CreateTHComponentPad(NewPCBLibComp, '17', eRoundHole, 0.95, 0, eBottomLayer, -3, 11, 0, 0, eRounded, 1.43, 1.43, eRounded, 1.43, 1.43, eRounded, 1.43, 1.43, 0, 0, -1.43, 0, True);
        CreateTHComponentPad(NewPCBLibComp, '18', eRoundHole, 0.95, 0, eBottomLayer, -5, 11, 0, 0, eRounded, 1.43, 1.43, eRounded, 1.43, 1.43, eRounded, 1.43, 1.43, 0, 0, -1.43, 0, True);
        CreateTHComponentPad(NewPCBLibComp, '19', eRoundHole, 0.95, 0, eBottomLayer, -7, 11, 0, 0, eRounded, 1.43, 1.43, eRounded, 1.43, 1.43, eRounded, 1.43, 1.43, 0, 0, -1.43, 0, True);
        CreateTHComponentPad(NewPCBLibComp, '20', eRoundHole, 0.95, 0, eBottomLayer, -9, 11, 0, 0, eRounded, 1.43, 1.43, eRounded, 1.43, 1.43, eRounded, 1.43, 1.43, 0, 0, -1.43, 0, True);

        CreateComponentTrack(NewPCBLibComp, -13.91, -11.97, -13.91, 11.97, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, -13.91, 11.97, 13.91, 11.97, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, 13.91, 11.97, 13.91, -11.97, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, 13.91, -11.97, -13.91, -11.97, eMechanical15, 0.05, False);
        CreateComponentArc(NewPCBLibComp, 0, 0, 0.25, 0, 360, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, 0, 0.35, 0, -0.35, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, -0.35, 0, 0.35, 0, eMechanical15, 0.05, False);
        CreateComponentTrack(NewPCBLibComp, -13.66, -11.19, -13.66, 11.19, eMechanical11, 0.12, False);
        CreateComponentTrack(NewPCBLibComp, -13.66, 11.19, 13.66, 11.19, eMechanical11, 0.12, False);
        CreateComponentTrack(NewPCBLibComp, 13.66, 11.19, 13.66, -11.19, eMechanical11, 0.12, False);
        CreateComponentTrack(NewPCBLibComp, 13.66, -11.19, -13.66, -11.19, eMechanical11, 0.12, False);
        CreateComponentTrack(NewPCBLibComp, -8.24, -11.19, -13.66, -11.19, eTopOverlay, 0.12, False);
        CreateComponentTrack(NewPCBLibComp, -13.66, -11.19, -13.66, 11.19, eTopOverlay, 0.12, False);
        CreateComponentTrack(NewPCBLibComp, -13.66, 11.19, -11.85, 11.19, eTopOverlay, 0.12, False);
        CreateComponentTrack(NewPCBLibComp, 11.85, -11.19, 13.66, -11.19, eTopOverlay, 0.12, False);
        CreateComponentTrack(NewPCBLibComp, 13.66, -11.19, 13.66, 11.19, eTopOverlay, 0.12, False);
        CreateComponentTrack(NewPCBLibComp, 13.66, 11.19, 11.85, 11.19, eTopOverlay, 0.12, False);

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

    CreateComponentDIPS2200W51P200L2731H700Q20(0);

End;

End.
