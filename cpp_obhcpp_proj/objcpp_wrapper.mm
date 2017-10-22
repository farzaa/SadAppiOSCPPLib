//
//  objcpp_wrapper.m
//  cpp_obhcpp_proj
//
//  Created by Flynn on 10/20/17.
//  Copyright © 2017 Flynn. All rights reserved.
//

#import "objcpp_wrapper.h"
#include "junk.h"
#include <cinttypes>
#include <fstream>
#include "draco/compression/decode.h"
#include "draco/core/cycle_timer.h"
#include "draco/io/obj_encoder.h"
#include "draco/io/parser_utils.h"
#include "draco/io/ply_encoder.h"

//#include "mesh_io.h"

//struct Options {
//    Options();
//    std::string input;
//    std::string output;
//};

//struct OptionsWrapper {
//    draco::Options *options;
//};
//
//
//@implementation OptionsWrapperWrapper
//
//- (id) init {
//    if (self = [super init]) {
//        optionsWrapper = new OptionsWrapper();
//        optionsWrapper->options = new draco::Options;
//    } return self;
//}
//
//- (void) dealloc {
//    delete optionsWrapper->options;
//    delete optionsWrapper;
//}
//
//@end
//
//struct DecoderWrapper {
//    draco::Decoder decoder;
//};
//
//@implementation DecoderWrapperWrapper
//
//- (id) init {
//    if (self = [super init]) {
////        decoderWrapper = new DecoderWrapper();
////        decoderWrapper->decoder = new draco::Decoder;
//    } return self;
//}
//
//- (void) dealloc {
////    delete decoderWrapper->decoder;
//    delete decoderWrapper;
//}
//
//- (void) loadMesh {
//    decoder.DecodeFromPointCloud
////    options.input = "Hey guys! I am input.";
////    options.output = "Hey guys! I am output.";
////    std::string output = "Hey guys! I am output.";
////    NSLog(@"%s", output.c_str());
////    std::ifstream input_file(options.input, std::ios::binary);
//}

@implementation NewDecoderWrapper
- (void)loadMesh {
    NSLog(@"Hello from loadMesh");
    NSLog(@"Lets stream in our input file...");

    std::ifstream input_file("/Users/flynn/Downloads/mickyd-1_med/out.drc", std::ios::binary);
    if (!input_file) {
        printf("Failed opening the input file.\n");
    }
    
    // Read the file stream into a buffer.
    std::streampos file_size = 0;
    input_file.seekg(0, std::ios::end);
    file_size = input_file.tellg() - file_size;
    input_file.seekg(0, std::ios::beg);
    std::vector<char> data(file_size);
    input_file.read(data.data(), file_size);
    
    if (data.empty()) {
        printf("Empty input file.\n");
    }
    
    NSLog(@"Loaded ");
    draco::DecoderBuffer buffer;
    buffer.Init(data.data(), data.size());
    
//    draco::CycleTimer timer;
    // Decode the input data into a geometry.
    std::unique_ptr<draco::PointCloud> pc;
    draco::Mesh *mesh = nullptr;
    auto type_statusor = draco::Decoder::GetEncodedGeometryType(&buffer);
    if (!type_statusor.ok()) {
//        return ReturnError(type_statusor.status());
    }
    const draco::EncodedGeometryType geom_type = type_statusor.value();
    if (geom_type == draco::TRIANGULAR_MESH) {

        draco::Decoder decoder;
        auto statusor = decoder.DecodeMeshFromBuffer(&buffer);
        if (!statusor.ok()) {
//            return ReturnError(statusor.status());
        }
        std::unique_ptr<draco::Mesh> in_mesh = std::move(statusor).value();

        if (in_mesh) {
            mesh = in_mesh.get();
            pc = std::move(in_mesh);
        }
    } else if (geom_type == draco::POINT_CLOUD) {
        // Failed to decode it as mesh, so let's try to decode it as a point cloud.

        draco::Decoder decoder;
        auto statusor = decoder.DecodePointCloudFromBuffer(&buffer);
        if (!statusor.ok()) {
//            return ReturnError(statusor.status());
        }
        pc = std::move(statusor).value();

    }

    if (pc == nullptr) {
        printf("Failed to decode the input file.\n");
    }
    
//    if (options.output.empty()) {
//        // Save the output model into a ply file.
//        options.output = options.input + ".ply";
//    }
    
//     Save the decoded geometry into a file.
//     TODO(ostava): Currently only .ply and .obj are supported.
    const std::string extension = draco::parser::ToLower(".obj");
    const std::string outPath = "/Users/flynn/Downloads/mickyd-1_med_2/ios_out/out.obj";
    if (extension == ".obj") {
        draco::ObjEncoder obj_encoder;
        if (mesh) {
            if (!obj_encoder.EncodeToFile(*mesh, outPath)) {
                printf("Failed to store the decoded mesh as OBJ.\n");

            }
        } else {
            if (!obj_encoder.EncodeToFile(*pc.get(), outPath)) {
                printf("Failed to store the decoded point cloud as OBJ.\n");

            }
        }
    } else if (extension == ".ply") {
        draco::PlyEncoder ply_encoder;
        if (mesh) {
            if (!ply_encoder.EncodeToFile(*mesh, outPath)) {
                printf("Failed to store the decoded mesh as PLY.\n");

            }
        } else {
            if (!ply_encoder.EncodeToFile(*pc.get(), outPath)) {
                printf("Failed to store the decoded point cloud as PLY.\n");

            }
        }
    } else {
        printf("Invalid extension of the output file. Use either .ply or .obj\n");

    }
}
@end

