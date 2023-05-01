if test x$2 = x; then
    echo usage is: make-release TAG RELEASE_NOTE_FILE
    exit 1
fi
if test -e $2; then
    echo release file found
else
    echo The release notes file does not exist
    exit 1
fi

TAG=$1
ZIPNAME=SkiaSharp.xcframework.zip
GIT_REMOTE_URL_UNFINISHED=`git config --get remote.origin.url|sed "s=^ssh://==; s=^https://==; s=:=/=; s/git@//; s/.git$//;"`
DOWNLOAD_URL=https://$GIT_REMOTE_URL_UNFINISHED/releases/download/$TAG/$ZIPNAME

perl -pi -e "s,url: \"https:.*SkiaSharp.xcframework.zip\",url: \"$DOWNLOAD_URL\"," Package.swift

git commit -m "Release version $TAG" -a
git tag -f $TAG
git push
git push --tags --force
gh release create "$TAG" $ZIPNAME --title "$TAG" --notes-file $2
