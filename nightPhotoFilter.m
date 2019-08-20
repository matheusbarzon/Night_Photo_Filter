%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Autor     : Mateus Pires Tonon; Matheus Barzon Lima
% Descrição : * Alteração do strechting
%             * Alteração do brilho
%             * Remoção de ruído
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
clc;

before_Folder = 'BD_Before';
after_Folder  = '.\BD_After\';

files = dir(strcat(before_Folder,'/*.jpeg')); 
for img = 1 : length(files)    
  nameOfFile = strcat(before_Folder,files(img).name); 
  nameOfFile_NoFilter = strcat(BD_After,'NoFilter_',arquivos(img).name);
  nameOfFile_CyanFilter = strcat(BD_After,'\Cyan_',arquivos(img).name); 
  img = imread(nameOfFile); 
  imgGray = rgb2gray(img);
  sizeOfImage=size(img);
  
  imgStrecht_1   = uint8(zeros(sizeOfImage(1),sizeOfImage(2),sizeOfImage(3)));
  imgStrecht_2   = uint8(zeros(sizeOfImage(1),sizeOfImage(2),sizeOfImage(3)));
  sumStrechtImg  = uint8(zeros(sizeOfImage(1),sizeOfImage(2),sizeOfImage(3)));
  imgMedfilt     = uint8(zeros(sizeOfImage(1),sizeOfImage(2),sizeOfImage(3))); 
    
  for k=1:sizeOfImage(3) %Transferencia, pelo strecht, dos pixels para pontos mais medianos
    maxValuePixel(k) = max(max(img(:,:,k)));
    minValuePixel(k) = min(min(img(:,:,k)));
    constant(k)=double((192-64)/double(maxValuePixel(k)-minValuePixel(k)));
    imgStrecht_1(:,:,k) = constant(k)*uint8(img(:,:,k)-minValuePixel(k))+64;
  end

  sumStrechtImg = imgStrecht_1+img; %Aumento do brilho da imagem
  for i=1:sizeOfImage(1) 
    for j=1:sizeOfImage(2)
      sumStrechtImg(i,j,:)=sumStrechtImg(i,j,:)+img(i,j,:)*2^(.585-imgGray(i,j)*0.002);
    end
  end
  
  for k=1:sizeOfImage(3) %strecht para recalcular e manter os pontos escuros
    maxValuePixel(k) = max(max(sumStrechtImg(:,:,k)));
    minValuePixel(k) = min(min(sumStrechtImg(:,:,k)));
    constant(k)=double((maxValuePixel(k)-0)/double(maxValuePixel(k)-minValuePixel(k)));
    imgStrecht_2(:,:,k) = constant(k)*uint8(sumStrechtImg(:,:,k)-minValuePixel(k))+0;
  end
    
  for k=1:sizeOfImage(3) %Remoção de ruido
    imgMedfilt(:,:,k) = medfilt2(imgStrecht_2(:,:,k), [3, 3]);
  end
  
  imgMedfiltCor=imgMedfilt;    
  imgMedfiltCor(:,:,1) = imgMedfilt(:,:,1)-15; %Aumento da cor ciano com a redução da cor vermelha
  
  imwrite(imgMedfilt,nameOfFile_NoFilter); 
  imwrite(imgMedfiltCor,nameOfFile_CyanFilter); 
end
