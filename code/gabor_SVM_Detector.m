clear
close all

% Imports
addpath('dataset');
addpath('functions');
addpath('functions/SVM-KM');
addpath('functions/Detectors');

load('gabor_SVM.mat'); % Model name is gaborSVMModel
windowSize = [18, 27]; % Window Size is the size of the test set images

images{1} = imread('images/im1.jpg');
images{2} = imread('images/im2.jpg');
images{3} = imread('images/im3.jpg');
images{4} = imread('images/im4.jpg');

prefix = "results/gabor_SVM_im";
suffix = ".jpg";

for iNumber = 1:4
    fprintf("Starting image number %d\n", iNumber);
    figure(iNumber);
    thisImg = cell2mat(images(iNumber));
    
    % Performs contrast enhancement using matlabs adapthisteq function
    thisImg = adapthisteq(thisImg);
    
    imshow(thisImg); % Shows Image

    % Gets boundingboxes for the test image, this should indicate a face
    % detected
    bBoxes = GaborSVMDetector(gaborSVMModel, thisImg, windowSize);
    fprintf("Bounding Boxes got for image number %d\n", iNumber);
    
    bBoxes = simpleNMS(bBoxes, 0.1);
    
    % Goes through all of the bounding boxes and displays them on the image
    for i = 1:size(bBoxes,1) 
        rectangle('Position',[bBoxes(i, 1),bBoxes(i, 2),bBoxes(i, 3) - bBoxes(i, 1),bBoxes(i, 4) - bBoxes(i, 2)],'LineWidth',3, 'EdgeColor','g');
    end
    fprintf("Bounding Boxes drawn for image number %d\n", iNumber);
    
    filename = strcat(prefix, int2str(iNumber), suffix);
    set (gcf, 'PaperPositionMode', 'manual','PaperPosition',[0, 0, 50, 30])
    print(figure(iNumber),filename,'-djpeg'); 
    fprintf("Saved image number %d\n", iNumber);
    
    fprintf("Finished image number %d\n", iNumber);
end

