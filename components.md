// showDialog(
                //   context: context,
                //   builder: (_) => AlertDialog(
                //     content: Column(
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         GestureDetector(
                //           onTap: () async {
                //             if (!_isRecording) {
                //               if (await record.hasPermission()) {
                //                 await record.start(
                //                   const RecordConfig(),
                //                   path: 'note_audio.m4a',
                //                 );
                //               } else {
                //                 final path = await record.stop();
                //                 setState(() => _isRecording = false);

                //                 if (path != null) {
                //                   final fileBytes = await File(
                //                     path,
                //                   ).readAsBytes();

                //                   if (widget.note != null) {
                //                     widget.note!.audioData = fileBytes;
                //                     await widget.note!.save();
                //                   } else {
                //                     audioFile = File(path);
                //                   }
                //                 }
                //               }
                //             }
                //           },
                //           child: Container(
                //             width: 40,
                //             height: 40,
                //             decoration: BoxDecoration(shape: BoxShape.circle),
                //             child: Center(
                //               child: Icon(
                //                 _isRecording
                //                     ? FluentIcons.stop_24_regular
                //                     : FluentIcons.mic_24_regular,
                //               ),
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // );