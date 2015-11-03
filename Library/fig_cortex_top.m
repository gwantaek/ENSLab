function fig_cortex_top(mesh, X, scale)

    if isempty(scale)
        if max(X) == 0
            scale = [0 1];
        else
            scale = [min(X) max(X) * 0.7];
        end            
    end

    set(gcf,'nextplot','add', 'Color',[0 0 0]);
    H3=trisurf(mesh.faces,mesh.vertices(:,1),mesh.vertices(:,2),mesh.vertices(:,3),'edgecolor','none');
    colormap('Jet(256)');
    set(H3,'FaceVertexcdata',X,'facealpha',1,'FaceLighting', 'phong');
    set(H3, 'facelighting','phong','edgelighting','phong');
    set(gca,'NextPlot','add');
    caxis(scale);
    axis off;     
%     title('Top');
    light;
    light('position',[0 0 1]);
    view(-90,90);
    axis equal;
    shading interp;

end