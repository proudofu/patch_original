function output_FileInfo = moviefile_info(MovieName)

persistent FileInfo;

movieObject = VideoReader(MovieName);

FileInfo.NumFrames = movieObject.NumberOfFrames;
FileInfo.Height = movieObject.Height;
FileInfo.Width = movieObject.Width;
FileInfo.VideoCompression = [];
FileInfo.FrameRate = movieObject.FrameRate;

output_FileInfo = FileInfo;

return;
end
