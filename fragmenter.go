package main

import (
	"bytes"
	"fmt"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"strings"
)

type empty struct{}

func main() {
	src := "/Users/saravanansilvarajoo/Media/mez/tearsOfSteel.mp4"

	segment := 10
	duration := getMezDurationInSeconds(src) / segment
	rendition := []int{350, 500}

	log.Printf("duration: %d", duration)

	sem := make(chan empty, duration) // semaphore pattern

	for i := 0; i < len(rendition); i++ {
		dst := makeRenditionDir(src, rendition[i])
		for j := 0; j < duration; j++ {
			go func(iteration int, segment int, dstFilename string) {
				splitIntoMp4(src, iteration, segment, dstFilename)
				sem <- empty{}
			}(j, segment, dst)
		}
	}

	for i := 0; i < duration; i++ {
		<-sem
	}
}

func getMezDurationInSeconds(src string) (seconds int) {

	//cmd := exec.Command("ffprobe", "-v", "error", "-show_entries", "format=duration", "-of", "default=noprint_wrappers=1:nokey=1", src)
	cmd := exec.Command("bash", "-c", "ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "+src)
	var stdout, stderr bytes.Buffer
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr

	err := cmd.Run()
	if err != nil {
		log.Fatalf("%s, %s", stderr.String(), err.Error())
	}

	// we are dropping the milliseconds
	seconds, _ = strconv.Atoi(strings.Split(stdout.String(), ".")[0])

	// add 1 second to cover for the lost milliseconds
	seconds++

	return
}

func splitIntoMp4(filename string, iteration int, segement int, dstFilename string) {

	dstFilename = fmt.Sprintf("%s_%0d.mp4", dstFilename, iteration)
	cmd := exec.Command("ffmpeg", "-ss", fmt.Sprintf("00:00:%0d.000", iteration*segement), "-i", filename, "-t", fmt.Sprintf("%0d", segement),
		"-b:v", "350K", "-b:a", "64K", "-maxrate", "350K", "-minrate", "350K", "-bufsize",
		"350K", dstFilename)
	var out, errB bytes.Buffer
	cmd.Stdout = &out
	cmd.Stderr = &errB

	err := cmd.Start()
	if err != nil {
		log.Fatalf("%s, %s", errB.String(), err.Error())
	}
	log.Printf("Transcoding %s...", dstFilename)
	err = cmd.Wait()
	if err != nil {
		log.Fatalf("Transcoding %s... FAILED [%s]", dstFilename, err.Error())
	}

	log.Printf("Transcoding %s... Done", dstFilename)
}

func makeRenditionDir(filename string, rendition int) string {
	dir := filepath.Dir(filename)
	newDir := fmt.Sprintf("%s/%0d", dir, rendition)

	// remove the directory and it's contents if it exists
	os.RemoveAll(newDir)

	// then create the directory
	err := os.Mkdir(newDir, 0755)
	if err != nil {
		log.Fatalln(err)
	}

	return (newDir + "/" + filepath.Base(filename))
}
