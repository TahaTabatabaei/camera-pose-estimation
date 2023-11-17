function points = barcodeFinder(I)
    points = zeros(9,2);    
    for i = 1:9
        imshow(I);
    
        roi1 = drawrectangle;
        roi = roi1.Position;
    
        % Search the image for a QR Code.
        [msg, format, loc] = readBarcode(I,roi(1,:),"QR-CODE");
         disp("Decoded format and message: " + format + ", " + msg)
        
        % Annotate the image with the decoded message.
        xyText =  loc(2,:);
        Imsg = insertText(I, xyText, msg, "BoxOpacity", 1, "FontSize", 25);
        
        % Insert filled circles at the finder pattern locations.
        Imsg = insertShape(Imsg, "filled-circle", [loc, ...
            repmat(10, length(loc), 1)], "Opacity", 1);
       
        points(i,:) = xyText;
        save("imagePoints.mat","points");

        % Display image.
        imshow(Imsg);        
    end
end