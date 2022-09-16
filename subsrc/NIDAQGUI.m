classdef NIDAQGUI < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure              matlab.ui.Figure
        StartrecordingButton  matlab.ui.control.Button
        StarttrialButton      matlab.ui.control.Button
        StoprecordingButton   matlab.ui.control.Button
        NIDAQrecorderLabel    matlab.ui.control.Label
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: StartrecordingButton
        function StartrecordingButtonPushed(app, event)
            wrapper('nidaq_recoder = nidaq_recoder.start_recording;');
        end

        % Button pushed function: StarttrialButton
        function StarttrialButtonPushed(app, event)
            wrapper('nidaq_recoder = nidaq_recoder.start_trial;');            
        end

        % Button pushed function: StoprecordingButton
        function StoprecordingButtonPushed(app, event)
            wrapper('nidaq_recoder = nidaq_recoder.stop_recording;');
            wrapper('nidaq_save_data');
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [1 1 1];
            app.UIFigure.Position = [100 100 652 159];
            app.UIFigure.Name = 'MATLAB App';

            % Create StartrecordingButton
            app.StartrecordingButton = uibutton(app.UIFigure, 'push');
            app.StartrecordingButton.ButtonPushedFcn = createCallbackFcn(app, @StartrecordingButtonPushed, true);
            app.StartrecordingButton.IconAlignment = 'center';
            app.StartrecordingButton.FontSize = 20;
            app.StartrecordingButton.FontWeight = 'bold';
            app.StartrecordingButton.Position = [34 30 159 66];
            app.StartrecordingButton.Text = 'Start recording';

            % Create StarttrialButton
            app.StarttrialButton = uibutton(app.UIFigure, 'push');
            app.StarttrialButton.ButtonPushedFcn = createCallbackFcn(app, @StarttrialButtonPushed, true);
            app.StarttrialButton.FontSize = 20;
            app.StarttrialButton.FontWeight = 'bold';
            app.StarttrialButton.Position = [247 30 159 66];
            app.StarttrialButton.Text = 'Start trial';

            % Create StoprecordingButton
            app.StoprecordingButton = uibutton(app.UIFigure, 'push');
            app.StoprecordingButton.ButtonPushedFcn = createCallbackFcn(app, @StoprecordingButtonPushed, true);
            app.StoprecordingButton.FontSize = 20;
            app.StoprecordingButton.FontWeight = 'bold';
            app.StoprecordingButton.Position = [459 30 159 66];
            app.StoprecordingButton.Text = 'Stop recording';

            % Create NIDAQrecorderLabel
            app.NIDAQrecorderLabel = uilabel(app.UIFigure);
            app.NIDAQrecorderLabel.FontSize = 20;
            app.NIDAQrecorderLabel.FontWeight = 'bold';
            app.NIDAQrecorderLabel.Position = [34 119 157 24];
            app.NIDAQrecorderLabel.Text = 'NIDAQ recorder';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = NIDAQGUI

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end