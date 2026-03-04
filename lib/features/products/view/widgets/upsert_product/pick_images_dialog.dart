import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;

import 'package:store_dashboard/utils/gen/app_strings.dart';

bool get _supportsImageCompression {
  return !kIsWeb && (Platform.isAndroid || Platform.isIOS || Platform.isMacOS);
}

Future<List<File>> openPickImagesDialog(BuildContext context) async {
  final pickedFiles = <File>[];

  await showDialog<void>(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: Text(AppStrings.pickImages),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Select multiple images for this color variant',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () async {
                          final result = await FilePicker.platform.pickFiles(
                            type: FileType.image,
                            allowMultiple: true,
                            withData: false,
                          );
                          if (result != null && result.files.isNotEmpty) {
                            for (final file in result.files) {
                              final path = file.path;
                              if (path == null || path.trim().isEmpty) continue;

                              var finalPath = path;
                              final fileSize = await File(path).length();

                              // Compress if > 2MB (only on supported platforms)
                              if (fileSize > 2 * 1024 * 1024 &&
                                  _supportsImageCompression) {
                                final dir = p.dirname(path);
                                final name = p.basenameWithoutExtension(path);
                                final ext = p.extension(path);
                                final compressedPath =
                                    '$dir/${name}_compressed$ext';

                                final compressed =
                                    await FlutterImageCompress.compressAndGetFile(
                                      path,
                                      compressedPath,
                                      quality: 85,
                                      minWidth: 1920,
                                      minHeight: 1920,
                                    );
                                if (compressed != null) {
                                  finalPath = compressed.path;
                                }
                              }

                              pickedFiles.add(File(finalPath));
                            }
                            setState(() {});
                          }
                        },
                        icon: const Icon(Icons.add_photo_alternate_outlined),
                        label: Text(AppStrings.pickImages),
                      ),
                      const SizedBox(height: 12),
                      if (pickedFiles.isEmpty)
                        Text(
                          AppStrings.noImagesSelected,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        )
                      else
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(pickedFiles.length, (i) {
                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    pickedFiles[i],
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: InkWell(
                                    onTap: () {
                                      pickedFiles.removeAt(i);
                                      setState(() {});
                                    },
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(
                                          alpha: 0.6,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        size: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              pickedFiles.clear();
              Navigator.of(ctx).pop();
            },
            child: Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(AppStrings.apply),
          ),
        ],
      );
    },
  );

  return pickedFiles;
}
