function export_track(innerCones, outerCones)
    fid = fopen("Data\track_FSI.txt","w");
    fprintf(fid, "%f %f\n", innerCones');
    fprintf(fid, "---\n");
    fprintf(fid, "%f %f\n", outerCones');
    fclose(fid);
end