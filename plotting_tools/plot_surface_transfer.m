clear
close all

      
p = param_main(400, 1, 1);
surf = boundary_surface(p);

%  Un-quad-averaged surface transfer matrices
   RmatAWsub = surf.RmatAWsub;
   RmatWAsub = surf.RmatWAsub;
   TmatAWsub = surf.TmatAWsub;
   TmatWAsub = surf.TmatWAsub;
   
%  Quad-averaged surface transfer matrices
   RmatAWquad = surf.RmatAWquad;
   RmatWAquad = surf.RmatWAquad;
   TmatAWquad = surf.TmatAWquad;
   TmatWAquad = surf.TmatWAquad;
   
figure;
colormap bone;
tiledlayout(2,2);

nexttile; % R(-ep,+ep)
   imagesc(flip(RmatAWsub, 2));
   xticks([1, p.M*p.M0/3, 2*p.M*p.M0/3, p.M*p.M0])
   xticklabels(flip({'\pi/2', '\pi/6', '\pi/3', '0'}))
   yticks([1, p.M*p.M0/3, 2*p.M*p.M0/3, p.M*p.M0])
   yticklabels({'\pi/2', '\pi/6', '\pi/3', '0'})
   title('R matrix: air-water (subquad)');
   xlabel('Incident angle')
   ylabel('Reflection angle')

nexttile; % T(-ep,+ep)
   imagesc(flip(TmatAWsub, 2));
   xticks([1, p.M*p.M0/3, 2*p.M*p.M0/3, p.M*p.M0])
   xticklabels(flip({'\pi/2', '\pi/6', '\pi/3', '0'}))
   yticks([1, p.M*p.M0/3, 2*p.M*p.M0/3, p.M*p.M0])
   yticklabels({'\pi/2', '\pi/6', '\pi/3', '0'})
   title('T matrix: air-water (subquad)');
   xlabel('Incident angle')
   ylabel('Transmission angle')

nexttile; % R(+ep,-ep)
   imagesc(flip(RmatWAsub, 2));
   xticks([1, p.M*p.M0/3, 2*p.M*p.M0/3, p.M*p.M0])
   xticklabels(flip({'\pi/2', '\pi/6', '\pi/3', '0'}))
   yticks([1, p.M*p.M0/3, 2*p.M*p.M0/3, p.M*p.M0])
   yticklabels({'\pi/2', '\pi/6', '\pi/3', '0'})
   title('R matrix: water-air (subquad)');
   xlabel('Incident angle')
   ylabel('Reflection angle')

nexttile; % T(+ep,-ep)
   imagesc(flip(TmatWAsub, 2));
   xticks([1, p.M*p.M0/3, 2*p.M*p.M0/3, p.M*p.M0])
   xticklabels(flip({'\pi/2', '\pi/6', '\pi/3', '0'}))
   yticks([1, p.M*p.M0/3, 2*p.M*p.M0/3, p.M*p.M0])
   yticklabels({'\pi/2', '\pi/6', '\pi/3', '0'})
   title('T matrix: water-air (subquad)');
   xlabel('Incident angle')
   ylabel('Transmission angle')

saveas(gcf,'surface_transfer_subquad.png')

      
figure;
colormap bone;
tiledlayout(2,2);

nexttile; % R(-ep,+ep)
   imagesc(flip(RmatAWquad, 2));
   xticks([1, p.M/3, 2*p.M/3, p.M])
   xticklabels(flip({'\pi/2', '\pi/6', '\pi/3', '0'}))
   yticks([1, p.M/3, 2*p.M/3, p.M])
   yticklabels({'\pi/2', '\pi/6', '\pi/3', '0'})
   title('R matrix: air-water (quad)');
   xlabel('Incident angle')
   ylabel('Reflection angle')

nexttile; % T(-ep,+ep)
   imagesc(flip(TmatAWquad, 2));
   xticks([1, p.M/3, 2*p.M/3, p.M])
   xticklabels(flip({'\pi/2', '\pi/6', '\pi/3', '0'}))
   yticks([1, p.M/3, 2*p.M/3, p.M])
   yticklabels({'\pi/2', '\pi/6', '\pi/3', '0'})
   title('T matrix: air-water (quad)');
   xlabel('Incident angle')
   ylabel('Transmission angle')

nexttile; % R(+ep,-ep)
   imagesc(flip(RmatWAquad, 2));
   xticks([1, p.M/3, 2*p.M/3, p.M])
   xticklabels(flip({'\pi/2', '\pi/6', '\pi/3', '0'}))
   yticks([1, p.M/3, 2*p.M/3, p.M])
   yticklabels({'\pi/2', '\pi/6', '\pi/3', '0'})
   title('R matrix: water-air (quad)');
   xlabel('Incident angle')
   ylabel('Reflection angle')

nexttile; % T(+ep,-ep)
   imagesc(flip(TmatWAquad, 2));
   xticks([1, p.M/3, 2*p.M/3, p.M])
   xticklabels(flip({'\pi/2', '\pi/6', '\pi/3', '0'}))
   yticks([1, p.M/3, 2*p.M/3, p.M])
   yticklabels({'\pi/2', '\pi/6', '\pi/3', '0'})
   title('T matrix: water-air (quad)');
   xlabel('Incident angle')
   ylabel('Transmission angle')

saveas(gcf,'surface_transfer_quad.png')
