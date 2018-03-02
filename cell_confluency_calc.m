function varargout = cell_confluency_calc(varargin)
% CELL_CONFLUENCY_CALC MATLAB code for cell_confluency_calc.fig
%      CELL_CONFLUENCY_CALC, by itself, creates a new CELL_CONFLUENCY_CALC or raises the existing
%      singleton*.
%
%      H = CELL_CONFLUENCY_CALC returns the handle to a new CELL_CONFLUENCY_CALC or the handle to
%      the existing singleton*.
%
%      CELL_CONFLUENCY_CALC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CELL_CONFLUENCY_CALC.M with the given input arguments.
%
%      CELL_CONFLUENCY_CALC('Property','Value',...) creates a new CELL_CONFLUENCY_CALC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cell_confluency_calc_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cell_confluency_calc_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cell_confluency_calc

% Last Modified by GUIDE v2.5 04-Feb-2014 21:58:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cell_confluency_calc_OpeningFcn, ...
                   'gui_OutputFcn',  @cell_confluency_calc_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before cell_confluency_calc is made visible.
function cell_confluency_calc_OpeningFcn(hObject, eventdata, handles, varargin)
%cd ('C:\Program Files\MATLAB\R2013a\bin\BigProject')
handles.slider_value= -0.22;
handles.k=0.1;
set(handles.edit3,'string',handles.slider_value)
handles.log= 'logsheet.xls';
handles.p=2 %metrhths excel
hold off
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cell_confluency_calc (see VARARGIN)

% Choose default command line output for cell_confluency_calc
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes cell_confluency_calc wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = cell_confluency_calc_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
handles.output = hObject;
[fn, pn] = uigetfile('*.jpg','Please select your image file');
impath = strcat(pn,fn);
set(handles.edit1,'string',impath);
set(handles.edit2,'string','Press "Calculate Now"' );
I = imread(impath);
imshow(I,'Parent',handles.axes1);
pause(5)
handles.BI = I;%backup gia toggle buttpn
run('grayklim.m');
CI= I; %backup gia mask ths eikonas black and white parakatw
run('filterit.m');
run ('gemiseholes.m');
imshow(I,'Parent',handles.axes1);
pause(5)
level= graythresh(I) + handles.slider_value
blackwhite= im2bw(I,level) %metatroph se binary gia luminance<level
blackwhite= bwareaopen(blackwhite,100);%afairesh mikrwn object
imshow(blackwhite,'Parent',handles.axes1 )
handles.bw= blackwhite;
mask =uint8 (blackwhite);%metatroph asprou maurou se mhden kai ena
handles.blackcell= CI.*mask;%pollaplasiasmos pinakwn stoixeio epi stoixeio!giana emfanisw mono opou yparxoun 1 sthn arxikh eikona(kyttara
imshow (handles.blackcell,'Parent',handles.axes1 )
pause(5)
guidata(hObject, handles);

% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function pushbutton1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
A = sum(sum(handles.bw));
cell_pixels = A;
all_pixels= numel(handles.bw);
handles.perc_nu=(cell_pixels/all_pixels*100);
handles.perc = [num2str(cell_pixels/all_pixels*100) '%']
set(handles.edit2,'string',handles.perc )
plot(handles.axes2,handles.k, handles.perc_nu,'Marker', 'o','markeredgecolor','k','markerfacecolor','r', 'MarkerSize',10 )
hold on
handles.k=handles.k+0.1;
if handles.perc_nu>65
  h = warndlg({'Cell Confluency has reached Critical Levels!';'Please Check your Samples'},'Warning!')
end
mark=[ 'A',num2str(handles.p)]
xlswrite(handles.log,handles.perc_nu,'sheet1',mark)
handles.p=handles.p+1
guidata(hObject, handles);


% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in togglebutton1.
function  togglebutton1_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
	% Toggle button is pressed-take appropriate action  
  imshow( handles.BI,'Parent',handles.axes1  )
elseif button_state == get(hObject,'Min')
	imshow(handles.blackcell ,'Parent',handles.axes1 )
% Toggle button is not pressed-take appropriate action
end     
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton1.
function pushbutton1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% axes of the backround
ha = axes('units','normalized','position',[0 0 1 1]);
%   axes to the bottom
uistack(ha,'bottom');
% backround image used  
I=imread('texture.jpg');
hi=  imagesc(I);
colormap gray
%  handlevisibility off 
% axis invisible
set(ha,'handlevisibility','off','visible','off')
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
 handles.slider_value = get(hObject,'Value');
 set(handles.edit3,'string',handles.slider_value)
 set(handles.edit2,'string','Please Reselect image file')
 guidata(hObject, handles);
 
 %hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
handles.slider_value= -0.22;
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'));
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.slider1,'Value',-0.22 );
handles.slider_value= -0.22;
set(handles.edit3,'string',handles.slider_value);
guidata(hObject, handles);
set(handles.edit2,'string','Please Reselect image file');


function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
